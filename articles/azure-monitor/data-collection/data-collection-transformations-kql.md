---
title: Supported KQL features in Azure Monitor transformations
description: Supported KQL features in Azure Monitor transformations
ms.topic: article
ms.date: 10/15/2024
ms.reviewer: nikeist

---

# Supported KQL features in Azure Monitor transformations

[Transformations in Azure Monitor](data-collection-transformations.md) allow you to run a KQL query against incoming Azure Monitor data to filter or modify incoming data before it's stored in a Log Analytics workspace. This article details KQL considerations and supported features in transformation queries in addition to special operators that are only available in transformations.

Since transformations are applied to each record individually, they can't use any KQL operators that act on multiple records. Only operators that take a single row as input and return no more than one row are supported. For example, [summarize](/azure/data-explorer/kusto/query/summarizeoperator) isn't supported since it summarizes multiple records.

Only the operators listed in this article are supported in transformations. Any other operators that may be used in other log queries are not supported in transformations.

## Special considerations

### Parse command

The [parse](/kusto/query/parse-operator) command in a transformation is limited to 10 columns per statement for performance reasons. If your transformation requires parsing more than 10 columns, split it into multiple statements as described in [Break up large parse commands](../logs/query-optimization.md#break-up-large-parse-commands).

### Handling dynamic data

Consider the following input with [dynamic data](/azure/data-explorer/kusto/query/scalar-data-types/dynamic):

```json
{
    "TimeGenerated" : "2021-11-07T09:13:06.570354Z",
    "Message": "Houston, we have a problem",
    "AdditionalContext": {
        "Level": 2,
        "DeviceID": "apollo13"
    }
}
```

To access the properties in *AdditionalContext*, define it as dynamic-type column in the input stream:

```json
"columns": [
    {
        "name": "TimeGenerated",
        "type": "datetime"
    },
    {
        "name": "Message",
        "type": "string"
    }, 
    {
        "name": "AdditionalContext",
        "type": "dynamic"
    }
]
```

The content of the *AdditionalContext* column can now be parsed and used in the KQL transformation:

```kusto
source
| extend parsedAdditionalContext = parse_json(AdditionalContext)
| extend Level = toint (parsedAdditionalContext.Level)
| extend DeviceId = tostring(parsedAdditionalContext.DeviceID)
```

## Dynamic literals

Use the [`parse_json` function](/azure/data-explorer/kusto/query/parsejsonfunction) to handle [dynamic literals](/azure/data-explorer/kusto/query/scalar-data-types/dynamic#dynamic-literals).

For example, the following queries provide the same functionality:

```kql
print d=dynamic({"a":123, "b":"hello", "c":[1,2,3], "d":{}})
```

```kql
print d=parse_json('{"a":123, "b":"hello", "c":[1,2,3], "d":{}}')
```

## Special functions

The following functions are only available in transformations. They cannot be used in other log queries.

### `parse_cef_dictionary`

Given a string containing a CEF message, `parse_cef_dictionary` parses the Extension property of the message into a dynamic key/value object. Semicolon is a reserved character that should be replaced prior to passing the raw message into the method, as shown in the example.

```kusto
| extend cefMessage=iff(cefMessage contains_cs ";", replace(";", " ", cefMessage), cefMessage) 
| extend parsedCefDictionaryMessage =parse_cef_dictionary(cefMessage) 
| extend parsecefDictionaryExtension = parsedCefDictionaryMessage["Extension"]
| project TimeGenerated, cefMessage, parsecefDictionaryExtension
```

:::image type="content" source="media/data-collection-transformations-structure/parse-cef-dictionary.png" lightbox="media/data-collection-transformations-structure/parse-cef-dictionary.png" alt-text="Sample output of parse_cef_dictionary function.":::

### `geo_location`

Given a string containing IP address (IPv4 and IPv6 are supported), `geo_location` function returns approximate geographical location, including the following attributes:
* Country
* Region
* State
* City
* Latitude
* Longitude

```kusto
| extend GeoLocation = geo_location("1.0.0.5")
```

:::image type="content" source="media/data-collection-transformations-structure/geo-location.png" lightbox="media/data-collection-transformations-structure/geo-location.png" alt-text="Screenshot of sample output of geo_location function.":::

> [!IMPORTANT]
> Due to nature of IP geolocation service utilized by this function, it may introduce data ingestion latency if used excessively. Exercise caution when using this function more than several times per transformation.

## Supported statements

###	Let statement

The right-hand side of [`let`](/azure/data-explorer/kusto/query/letstatement) can be a scalar expression, a tabular expression, or a user-defined function. Only user-defined functions with scalar arguments are supported.

### Tabular expression statements

The only supported data sources for the KQL statement in a transformation are as follows:

* **source**, which represents the source data. For example:

    ```kusto
    source
    | where ActivityId == "383112e4-a7a8-4b94-a701-4266dfc18e41"
    | project PreciseTimeStamp, Message
    ```

* [`print`](/azure/data-explorer/kusto/query/printoperator) operator, which always produces a single row. For example:

    ```kusto
    print x = 2 + 2, y = 5 | extend z = exp2(x) + exp2(y)
    ```

## Supported tabular operators

* [`extend`](/azure/data-explorer/kusto/query/extendoperator)
* [`project`](/azure/data-explorer/kusto/query/projectoperator)
* [`print`](/azure/data-explorer/kusto/query/printoperator)
* [`where`](/azure/data-explorer/kusto/query/whereoperator)
* [`parse`](/azure/data-explorer/kusto/query/parseoperator)
* [`project-away`](/azure/data-explorer/kusto/query/projectawayoperator)
* [`project-rename`](/azure/data-explorer/kusto/query/projectrenameoperator)
* [`datatable`](/azure/data-explorer/kusto/query/datatableoperator?pivots=azuremonitor)
* [`columnifexists`](/azure/data-explorer/kusto/query/columnifexists) (use columnifexists instead of column_ifexists)

## Supported scalar operators

* All [Numerical operators](/azure/data-explorer/kusto/query/numoperators) are supported.

* All [Datetime and Timespan arithmetic operators](/azure/data-explorer/kusto/query/datetime-timespan-arithmetic) are supported.

* The following [String operators](/azure/data-explorer/kusto/query/datatypes-string-operators) are supported.

    * `==`
    * `!=`
    * `=~`
    * `!~`
    * `contains`
    * `!contains`
    * `contains_cs`
    * `!contains_cs`
    * `has`
    * `!has`
    * `has_cs`
    * `!has_cs`
    * `startswith`
    * `!startswith`
    * `startswith_cs`
    * `!startswith_cs`
    * `endswith`
    * `!endswith`
    * `endswith_cs`
    * `!endswith_cs`
    * `matches regex`
    * `in`
    * `!in`

* The following [Bitwise operators](/azure/data-explorer/kusto/query/binoperators) are supported.

    * `binary_and()`
    * `binary_or()`
    * `binary_xor()`
    * `binary_not()`
    * `binary_shift_left()`
    * `binary_shift_right()`

## Scalar functions

* Bitwise functions

    * [`binary_and`](/azure/data-explorer/kusto/query/binary-andfunction)
    * [`binary_or`](/azure/data-explorer/kusto/query/binary-orfunction)
    * [`binary_not`](/azure/data-explorer/kusto/query/binary-notfunction)
    * [`binary_shift_left`](/azure/data-explorer/kusto/query/binary-shift-leftfunction)
    * [`binary_shift_right`](/azure/data-explorer/kusto/query/binary-shift-rightfunction)
    * [`binary_xor`](/azure/data-explorer/kusto/query/binary-xorfunction)

* Conversion functions

    * [`tobool`](/azure/data-explorer/kusto/query/toboolfunction)
    * [`todatetime`](/azure/data-explorer/kusto/query/todatetimefunction)
    * [`todouble`/toreal](/azure/data-explorer/kusto/query/todoublefunction)
    * [`toguid`](/azure/data-explorer/kusto/query/toguidfunction)
    * [`toint`](/azure/data-explorer/kusto/query/tointfunction)
    * [`tolong`](/azure/data-explorer/kusto/query/tolongfunction)
    * [`tostring`](/azure/data-explorer/kusto/query/tostringfunction)
    * [`totimespan`](/azure/data-explorer/kusto/query/totimespanfunction)

* DateTime and TimeSpan functions

    * [`ago`](/azure/data-explorer/kusto/query/agofunction)
    * [`datetime_add`](/azure/data-explorer/kusto/query/datetime-addfunction)
    * [`datetime_diff`](/azure/data-explorer/kusto/query/datetime-difffunction)
    * [`datetime_part`](/azure/data-explorer/kusto/query/datetime-partfunction)
    * [`dayofmonth`](/azure/data-explorer/kusto/query/dayofmonthfunction)
    * [`dayofweek`](/azure/data-explorer/kusto/query/dayofweekfunction)
    * [`dayofyear`](/azure/data-explorer/kusto/query/dayofyearfunction)
    * [`endofday`](/azure/data-explorer/kusto/query/endofdayfunction)
    * [`endofmonth`](/azure/data-explorer/kusto/query/endofmonthfunction)
    * [`endofweek`](/azure/data-explorer/kusto/query/endofweekfunction)
    * [`endofyear`](/azure/data-explorer/kusto/query/endofyearfunction)
    * [`getmonth`](/azure/data-explorer/kusto/query/getmonthfunction)
    * [`getyear`](/azure/data-explorer/kusto/query/getyearfunction)
    * [`hourofday`](/azure/data-explorer/kusto/query/hourofdayfunction)
    * [`make_datetime`](/azure/data-explorer/kusto/query/make-datetimefunction)
    * [`make_timespan`](/azure/data-explorer/kusto/query/make-timespanfunction)
    * [`now`](/azure/data-explorer/kusto/query/nowfunction)
    * [`startofday`](/azure/data-explorer/kusto/query/startofdayfunction)
    * [`startofmonth`](/azure/data-explorer/kusto/query/startofmonthfunction)
    * [`startofweek`](/azure/data-explorer/kusto/query/startofweekfunction)
    * [`startofyear`](/azure/data-explorer/kusto/query/startofyearfunction)
    * [`todatetime`](/azure/data-explorer/kusto/query/todatetimefunction)
    * [`totimespan`](/azure/data-explorer/kusto/query/totimespanfunction)
    * [`weekofyear`](/azure/data-explorer/kusto/query/weekofyearfunction)

* Dynamic and array functions

    * [`array_concat`](/azure/data-explorer/kusto/query/arrayconcatfunction)
    * [`array_length`](/azure/data-explorer/kusto/query/arraylengthfunction)
    * [`pack_array`](/azure/data-explorer/kusto/query/packarrayfunction)
    * [`pack`](/azure/data-explorer/kusto/query/packfunction)
    * [`parse_json`](/azure/data-explorer/kusto/query/parsejsonfunction)
    * [`parse_xml`](/azure/data-explorer/kusto/query/parse-xmlfunction)
    * [`zip`](/azure/data-explorer/kusto/query/zipfunction)

* Mathematical functions

    * [`abs`](/azure/data-explorer/kusto/query/abs-function)
    * [`bin`/`floor`](/azure/data-explorer/kusto/query/binfunction)
    * [`ceiling`](/azure/data-explorer/kusto/query/ceilingfunction)
    * [`exp`](/azure/data-explorer/kusto/query/exp-function)
    * [`exp10`](/azure/data-explorer/kusto/query/exp10-function)
    * [`exp2`](/azure/data-explorer/kusto/query/exp2-function)
    * [`isfinite`](/azure/data-explorer/kusto/query/isfinitefunction)
    * [`isinf`](/azure/data-explorer/kusto/query/isinffunction)
    * [`isnan`](/azure/data-explorer/kusto/query/isnanfunction)
    * [`log`](/azure/data-explorer/kusto/query/log-function)
    * [`log10`](/azure/data-explorer/kusto/query/log10-function)
    * [`log2`](/azure/data-explorer/kusto/query/log2-function)
    * [`pow`](/azure/data-explorer/kusto/query/powfunction)
    * [`round`](/azure/data-explorer/kusto/query/roundfunction)
    * [`sign`](/azure/data-explorer/kusto/query/signfunction)

* Conditional functions

    * [`case`](/azure/data-explorer/kusto/query/casefunction)
    * [`iif`](/azure/data-explorer/kusto/query/iiffunction)
    * [`max_of`](/azure/data-explorer/kusto/query/max-offunction)
    * [`min_of`](/azure/data-explorer/kusto/query/min-offunction)

* String functions

    * [`base64_encodestring`](/azure/data-explorer/kusto/query/base64_encode_tostringfunction) (use base64_encodestring instead of base64_encode_tostring)
    * [`base64_decodestring`](/azure/data-explorer/kusto/query/base64_decode_tostringfunction) (use base64_decodestring instead of base64_decode_tostring)
    * [`countof`](/azure/data-explorer/kusto/query/countoffunction)
    * [`extract`](/azure/data-explorer/kusto/query/extractfunction)
    * [`extract_all`](/azure/data-explorer/kusto/query/extractallfunction)
    * [`indexof`](/azure/data-explorer/kusto/query/indexoffunction)
    * [`isempty`](/azure/data-explorer/kusto/query/isemptyfunction)
    * [`isnotempty`](/azure/data-explorer/kusto/query/isnotemptyfunction)
    * [`parse_json`](/azure/data-explorer/kusto/query/parsejsonfunction)
    * [`split`](/azure/data-explorer/kusto/query/splitfunction)
    * [`strcat`](/azure/data-explorer/kusto/query/strcatfunction)
    * [`strcat_delim`](/azure/data-explorer/kusto/query/strcat-delimfunction)
    * [`strlen`](/azure/data-explorer/kusto/query/strlenfunction)
    * [`substring`](/azure/data-explorer/kusto/query/substringfunction)
    * [`tolower`](/azure/data-explorer/kusto/query/tolowerfunction)
    * [`toupper`](/azure/data-explorer/kusto/query/toupperfunction)
    * [`hash_sha256`](/azure/data-explorer/kusto/query/sha256hashfunction)

* Type functions

    * [`gettype`](/azure/data-explorer/kusto/query/gettypefunction)
    * [`isnotnull`](/azure/data-explorer/kusto/query/isnotnullfunction)
    * [`isnull`](/azure/data-explorer/kusto/query/isnullfunction)

## Identifier quoting

Use [Identifier quoting](/azure/data-explorer/kusto/query/schema-entities/entity-names?q=identifier#identifier-quoting) as required.

## Next steps

* [Create a data collection rule](../vm/data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
