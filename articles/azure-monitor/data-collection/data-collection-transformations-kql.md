---
title: Supported KQL features in Azure Monitor transformations
description: Reference list of KQL operators, functions, and statements supported in Azure Monitor data collection transformations.
ms.topic: reference
ms.date: 05/15/2026
ms.reviewer: nikeist
ai-usage: ai-assisted

---

# Supported KQL features in Azure Monitor transformations

[Transformations in Azure Monitor](data-collection-transformations.md) allow you to run a KQL query against incoming Azure Monitor data to filter or modify incoming data before it's stored in a Log Analytics workspace. This article details KQL considerations and supported features in transformation queries in addition to special operators that are only available in transformations.

Since transformations are applied to each record individually, they can't use any KQL operators that act on multiple records. Only operators that take a single row as input and return no more than one row are supported. For example, [summarize](/kusto/query/summarize-operator?view=azure-monitor&preserve-view=true) isn't supported since it summarizes multiple records.

Only the operators listed in this article are supported in transformations.

> [!NOTE]
> For [multi-stage transformations (preview)](data-collection-transformations.md#multi-stage-transformations-preview), the KQL features described in this article apply to the `transform.KQL` processor and to the `transformKql` property in data flows. Other processor types such as `filter.Basic`, `parse.JsonPath`, and `aggregate.Basic` use declarative JSON configuration rather than KQL. See [DCR structure - Processor types](data-collection-rule-structure.md#processor-types) for details.

## Special considerations

### Parse operator

The [parse](/kusto/query/parse-operator?view=azure-monitor&preserve-view=true) operator in a transformation is limited to 10 columns per statement for performance reasons. If your transformation requires parsing more than 10 columns, split it into multiple statements as described in [Break up large parse commands](../logs/query-optimization.md#break-up-large-parse-commands).

### Handle dynamic data

Consider the following input with [dynamic data](/kusto/query/scalar-data-types/dynamic?view=azure-monitor&preserve-view=true):

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

Use the [`parse_json` function](/kusto/query/parse-json-function?view=azure-monitor&preserve-view=true) to handle [dynamic literals](/kusto/query/scalar-data-types/dynamic?view=azure-monitor&preserve-view=true#dynamic-literals).

For example, the following queries provide the same functionality:

```kusto
print d=dynamic({"a":123, "b":"hello", "c":[1,2,3], "d":{}})
```

```kusto
print d=parse_json('{"a":123, "b":"hello", "c":[1,2,3], "d":{}}')
```

## Special functions

The following functions are only available in transformations. They can't be used in other log queries.

### `parse_cef_dictionary`

The `parse_cef_dictionary` function parses the Extension property of a CEF message into a dynamic key/value object. Semicolon is a reserved character that should be replaced before passing the raw message into the method, as shown in the example.

```kusto
| extend cefMessage=iff(cefMessage contains_cs ";", replace(";", " ", cefMessage), cefMessage) 
| extend parsedCefDictionaryMessage =parse_cef_dictionary(cefMessage) 
| extend parsecefDictionaryExtension = parsedCefDictionaryMessage["Extension"]
| project TimeGenerated, cefMessage, parsecefDictionaryExtension
```

:::image type="content" source="media/data-collection-transformations-structure/parse-cef-dictionary.png" lightbox="media/data-collection-transformations-structure/parse-cef-dictionary.png" alt-text="Table showing parsed CEF dictionary output with TimeGenerated, cefMessage, and parsed extension columns.":::

### `geo_location`

The `geo_location` function returns approximate geographical location for an IP address (IPv4 and IPv6 are supported), including the following attributes:
* Country
* Region
* State
* City
* Latitude
* Longitude

```kusto
| extend GeoLocation = geo_location("1.0.0.5")
```

:::image type="content" source="media/data-collection-transformations-structure/geo-location.png" lightbox="media/data-collection-transformations-structure/geo-location.png" alt-text="Table showing geo_location output with country, region, state, city, latitude, and longitude columns.":::

> [!IMPORTANT]
> This function calls an external IP geolocation service, which might add data ingestion latency. Use it sparingly—no more than a few times per transformation.

## Supported statements

###                   Let statement

The right-hand side of [`let`](/kusto/query/let-statement?view=azure-monitor&preserve-view=true) can be a scalar expression, a tabular expression, or a user-defined function. Only user-defined functions with scalar arguments are supported.

### Tabular expression statements

The only supported data sources for the KQL statement in a transformation are:

* **source**, which represents the source data. For example:

    ```kusto
    source
    | where ActivityId == "383112e4-a7a8-4b94-a701-4266dfc18e41"
    | project PreciseTimeStamp, Message
    ```

* [`print`](/kusto/query/print-operator?view=azure-monitor&preserve-view=true) operator, which always produces a single row. For example:

    ```kusto
    print x = 2 + 2, y = 5 | extend z = exp2(x) + exp2(y)
    ```

## Supported tabular operators

* [`extend`](/kusto/query/extend-operator?view=azure-monitor&preserve-view=true)
* [`project`](/kusto/query/project-operator?view=azure-monitor&preserve-view=true)
* [`print`](/kusto/query/print-operator?view=azure-monitor&preserve-view=true)
* [`where`](/kusto/query/where-operator?view=azure-monitor&preserve-view=true)
* [`parse`](/kusto/query/parse-operator?view=azure-monitor&preserve-view=true)
* [`project-away`](/kusto/query/project-away-operator?view=azure-monitor&preserve-view=true)
* [`project-rename`](/kusto/query/project-rename-operator?view=azure-monitor&preserve-view=true)
* [`datatable`](/kusto/query/datatable-operator?view=azure-monitor&preserve-view=true)
* [`columnifexists`](/kusto/query/column-ifexists-function?view=azure-monitor&preserve-view=true) (use `columnifexists` instead of `column_ifexists`)

## Supported scalar operators

* All [Numerical operators](/kusto/query/numerical-operators?view=azure-monitor&preserve-view=true) are supported.

* All [Datetime and Timespan arithmetic operators](/kusto/query/datetime-timespan-arithmetic?view=azure-monitor&preserve-view=true) are supported.

* The following [String operators](/kusto/query/datatypes-string-operators?view=azure-monitor&preserve-view=true) are supported.

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

* The following [Bitwise operators](/kusto/query/bin-operators?view=azure-monitor&preserve-view=true) are supported.

    * `binary_and()`
    * `binary_or()`
    * `binary_xor()`
    * `binary_not()`
    * `binary_shift_left()`
    * `binary_shift_right()`

## Scalar functions

* Bitwise functions

    * [`binary_and`](/kusto/query/binary-and-function?view=azure-monitor&preserve-view=true)
    * [`binary_or`](/kusto/query/binary-or-function?view=azure-monitor&preserve-view=true)
    * [`binary_not`](/kusto/query/binary-not-function?view=azure-monitor&preserve-view=true)
    * [`binary_shift_left`](/kusto/query/binary-shift-left-function?view=azure-monitor&preserve-view=true)
    * [`binary_shift_right`](/kusto/query/binary-shift-right-function?view=azure-monitor&preserve-view=true)
    * [`binary_xor`](/kusto/query/binary-xor-function?view=azure-monitor&preserve-view=true)

* Conversion functions

    * [`tobool`](/kusto/query/tobool-function?view=azure-monitor&preserve-view=true)
    * [`todatetime`](/kusto/query/todatetime-function?view=azure-monitor&preserve-view=true)
    * [`todouble`/ `toreal`](/kusto/query/toreal-function?view=azure-monitor&preserve-view=true)
    * [`toguid`](/kusto/query/toguid-function?view=azure-monitor&preserve-view=true)
    * [`toint`](/kusto/query/toint-function?view=azure-monitor&preserve-view=true)
    * [`tolong`](/kusto/query/tolong-function?view=azure-monitor&preserve-view=true)
    * [`tostring`](/kusto/query/tostring-function?view=azure-monitor&preserve-view=true)
    * [`totimespan`](/kusto/query/totimespan-function?view=azure-monitor&preserve-view=true)

* DateTime and TimeSpan functions

    * [`ago`](/kusto/query/ago-function?view=azure-monitor&preserve-view=true)
    * [`datetime_add`](/kusto/query/datetime-add-function?view=azure-monitor&preserve-view=true)
    * [`datetime_diff`](/kusto/query/datetime-diff-function?view=azure-monitor&preserve-view=true)
    * [`datetime_part`](/kusto/query/datetime-part-function?view=azure-monitor&preserve-view=true)
    * [`dayofmonth`](/kusto/query/day-of-month-function?view=azure-monitor&preserve-view=true)
    * [`dayofweek`](/kusto/query/day-of-week-function?view=azure-monitor&preserve-view=true)
    * [`dayofyear`](/kusto/query/day-of-year-function?view=azure-monitor&preserve-view=true)
    * [`endofday`](/kusto/query/endofday-function?view=azure-monitor&preserve-view=true)
    * [`endofmonth`](/kusto/query/endofmonth-function?view=azure-monitor&preserve-view=true)
    * [`endofweek`](/kusto/query/endofweek-function?view=azure-monitor&preserve-view=true)
    * [`endofyear`](/kusto/query/endofyear-function?view=azure-monitor&preserve-view=true)
    * [`getmonth` / `monthofyear`](/kusto/query/monthofyear-function?view=azure-monitor&preserve-view=true)
    * [`getyear`](/kusto/query/getyear-function?view=azure-monitor&preserve-view=true)
    * [`hourofday`](/kusto/query/hour-of-day-function?view=azure-monitor&preserve-view=true)
    * [`make_datetime`](/kusto/query/make-datetime-function?view=azure-monitor&preserve-view=true)
    * [`make_timespan`](/kusto/query/make-timespan-function?view=azure-monitor&preserve-view=true)
    * [`now`](/kusto/query/now-function?view=azure-monitor&preserve-view=true)
    * [`startofday`](/kusto/query/startofday-function?view=azure-monitor&preserve-view=true)
    * [`startofmonth`](/kusto/query/startofmonth-function?view=azure-monitor&preserve-view=true)
    * [`startofweek`](/kusto/query/startofweek-function?view=azure-monitor&preserve-view=true)
    * [`startofyear`](/kusto/query/startofyear-function?view=azure-monitor&preserve-view=true)
    * [`todatetime`](/kusto/query/todatetime-function?view=azure-monitor&preserve-view=true)
    * [`totimespan`](/kusto/query/totimespan-function?view=azure-monitor&preserve-view=true)
    * [`weekofyear`](/kusto/query/week-of-year-function?view=azure-monitor&preserve-view=true)

* Dynamic and array functions

    * [`array_concat`](/kusto/query/array-concat-function?view=azure-monitor&preserve-view=true)
    * [`array_length`](/kusto/query/array-length-function?view=azure-monitor&preserve-view=true)
    * [`pack`](/kusto/query/pack-function?view=azure-monitor&preserve-view=true)
    * [`pack_array`](/kusto/query/pack-array-function?view=azure-monitor&preserve-view=true)
    * [`parse_json`](/kusto/query/parse-json-function?view=azure-monitor&preserve-view=true)
    * [`parse_xml`](/kusto/query/parse-xml-function?view=azure-monitor&preserve-view=true)
    * [`zip`](/kusto/query/zip-function?view=azure-monitor&preserve-view=true)

* Mathematical functions

    * [`abs`](/kusto/query/abs-function?view=azure-monitor&preserve-view=true)
    * [`bin`/`floor`](/kusto/query/bin-function?view=azure-monitor&preserve-view=true)
    * [`ceiling`](/kusto/query/ceiling-function?view=azure-monitor&preserve-view=true)
    * [`exp`](/kusto/query/exp-function?view=azure-monitor&preserve-view=true)
    * [`exp10`](/kusto/query/exp10-function?view=azure-monitor&preserve-view=true)
    * [`exp2`](/kusto/query/exp2-function?view=azure-monitor&preserve-view=true)
    * [`isfinite`](/kusto/query/isfinite-function?view=azure-monitor&preserve-view=true)
    * [`isinf`](/kusto/query/isinf-function?view=azure-monitor&preserve-view=true)
    * [`isnan`](/kusto/query/isnan-function?view=azure-monitor&preserve-view=true)
    * [`log`](/kusto/query/log-function?view=azure-monitor&preserve-view=true)
    * [`log10`](/kusto/query/log10-function?view=azure-monitor&preserve-view=true)
    * [`log2`](/kusto/query/log2-function?view=azure-monitor&preserve-view=true)
    * [`pow`](/kusto/query/pow-function?view=azure-monitor&preserve-view=true)
    * [`round`](/kusto/query/round-function?view=azure-monitor&preserve-view=true)
    * [`sign`](/kusto/query/sign-function?view=azure-monitor&preserve-view=true)

* Conditional functions

    * [`case`](/kusto/query/case-function?view=azure-monitor&preserve-view=true)
    * [`iif`](/kusto/query/iff-function?view=azure-monitor&preserve-view=true)
    * [`max_of`](/kusto/query/max-of-function?view=azure-monitor&preserve-view=true)
    * [`min_of`](/kusto/query/min-of-function?view=azure-monitor&preserve-view=true)

* String functions

    * [`base64_encodestring`](/kusto/query/base64-encode-tostring-function?view=azure-monitor&preserve-view=true) (use `base64_encodestring` instead of `base64_encode_tostring`)
    * [`base64_decodestring`](/kusto/query/base64-decode-tostring-function?view=azure-monitor&preserve-view=true) (use `base64_decodestring` instead of `base64_decode_tostring`)
    * [`countof`](/kusto/query/countof-function?view=azure-monitor&preserve-view=true)
    * [`extract`](/kusto/query/extract-function?view=azure-monitor&preserve-view=true)
    * [`extract_all`](/kusto/query/extract-all-function?view=azure-monitor&preserve-view=true)
    * [`indexof`](/kusto/query/indexof-function?view=azure-monitor&preserve-view=true)
    * [`isempty`](/kusto/query/isempty-function?view=azure-monitor&preserve-view=true)
    * [`isnotempty`](/kusto/query/isnotempty-function?view=azure-monitor&preserve-view=true)
    * [`parse_json`](/kusto/query/parse-json-function?view=azure-monitor&preserve-view=true)
    * [`replace`](/kusto/query/replace-string-function?view=azure-monitor&preserve-view=true) (use `replace` instead of `replace_string`)
    * [`split`](/kusto/query/split-function?view=azure-monitor&preserve-view=true)
    * [`strcat`](/kusto/query/strcat-function?view=azure-monitor&preserve-view=true)
    * [`strcat_delim`](/kusto/query/strcat-delim-function?view=azure-monitor&preserve-view=true)
    * [`strlen`](/kusto/query/strlen-function?view=azure-monitor&preserve-view=true)
    * [`substring`](/kusto/query/substring-function?view=azure-monitor&preserve-view=true)
    * [`tolower`](/kusto/query/tolower-function?view=azure-monitor&preserve-view=true)
    * [`toupper`](/kusto/query/toupper-function?view=azure-monitor&preserve-view=true)
    * [`hash_sha256`](/kusto/query/hash-sha256-function?view=azure-monitor&preserve-view=true)

* Type functions

    * [`gettype`](/kusto/query/gettype-function?view=azure-monitor&preserve-view=true)
    * [`isnotnull`](/kusto/query/isnotnull-function?view=azure-monitor&preserve-view=true)
    * [`isnull`](/kusto/query/isnull-function?view=azure-monitor&preserve-view=true)

## Identifier quoting

Use [Identifier quoting](/kusto/query/schema-entities/entity-names?view=azure-monitor&preserve-view=true) as required.

## Related content

- [Create a data collection rule](../vm/data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
