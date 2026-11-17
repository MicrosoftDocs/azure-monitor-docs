---
title: Supported KQL features in Azure Monitor transformations
description: Reference list of KQL operators, functions, and statements supported in Azure Monitor data collection transformations.
ms.topic: reference
ms.date: 10/23/2026
ms.reviewer: nikeist
ai-usage: ai-assisted

---

# Supported KQL features in Azure Monitor transformations

[Transformations in Azure Monitor](data-collection-transformations.md) allow you to run a KQL query against incoming Azure Monitor data to filter or modify incoming data before it's stored in a Log Analytics workspace. This article details KQL considerations and supported features in transformation queries in addition to special operators that are only available in transformations.

Since transformations are applied to each record individually, they can't use any KQL operators that act on multiple records. Only operators that take a single row as input and return no more than one row are supported. For example, [summarize](/kusto/query/summarize-operator?view=azure-monitor&preserve-view=true) isn't supported since it summarizes multiple records.

Only the operators listed in this article are supported in transformations.

Some functions and operators behave differently in transformations than in queries against stored data. Review the [special considerations](#special-considerations) before you reuse a query in a transformation.

> [!NOTE]
> For [multi-stage transformations (preview)](data-collection-transformations.md#multi-stage-transformations-preview), the KQL features described in this article apply to the `transform.KQL` processor and to the `transformKql` property in data flows. Other processor types such as `filter.Basic`, `parse.JsonPath`, and `aggregate.Basic` use declarative JSON configuration rather than KQL. See [DCR structure - Processor types](data-collection-rule-structure.md#processor-types) for details.

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
* [`parse-kv`](/kusto/query/parse-kv-operator?view=azure-monitor&preserve-view=true) (see [Parse-kv operator](#parse-kv-operator))
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
    * [`tohex`](/kusto/query/tohex-function?view=azure-monitor&preserve-view=true) (see [Hexadecimal conversion](#hexadecimal-conversion))
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
    * [`bag_merge`](/kusto/query/bag-merge-function?view=azure-monitor&preserve-view=true) (see [Bag functions](#bag-functions))
    * [`bag_remove_keys`](/kusto/query/bag-remove-keys-function?view=azure-monitor&preserve-view=true) (top-level keys only; see [Bag functions](#bag-functions))
    * [`pack`](/kusto/query/pack-function?view=azure-monitor&preserve-view=true)
    * [`pack_all`](/kusto/query/pack-all-function?view=azure-monitor&preserve-view=true) (see [Bag functions](#bag-functions))
    * [`pack_array`](/kusto/query/pack-array-function?view=azure-monitor&preserve-view=true)
    * [`parse_json`](/kusto/query/parse-json-function?view=azure-monitor&preserve-view=true)
    * [`parse_xml`](/kusto/query/parse-xml-function?view=azure-monitor&preserve-view=true)
    * [`zip`](/kusto/query/zip-function?view=azure-monitor&preserve-view=true)

* IP functions

    * [`ipv4_is_in_range`](/kusto/query/ipv4-is-in-range-function?view=azure-monitor&preserve-view=true)
    * [`ipv4_is_match`](/kusto/query/ipv4-is-match-function?view=azure-monitor&preserve-view=true)
    * [`ipv4_is_private`](/kusto/query/ipv4-is-private-function?view=azure-monitor&preserve-view=true)
    * [`parse_ipv4`](/kusto/query/parse-ipv4-function?view=azure-monitor&preserve-view=true)
    * [`parse_ipv6`](/kusto/query/parse-ipv6-function?view=azure-monitor&preserve-view=true)

    For transformation-specific behavior and examples, see [IP parsing and classification](#ip-parsing-and-classification).

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

## Special considerations

### Parse operator

The [parse](/kusto/query/parse-operator?view=azure-monitor&preserve-view=true) operator in a transformation is limited to 10 columns per statement for performance reasons. If your transformation requires parsing more than 10 columns, split it into multiple statements as described in [Break up large parse commands](../logs/query-optimization.md#break-up-large-parse-commands).

> [!IMPORTANT]
> When you use `parse kind=regex` in a transformation, the regular expression must match the *entire* input string for the parsed columns to be populated. This behavior differs from Log Analytics and Microsoft Sentinel queries, where a partial match still populates the parsed fields. As a result, a `parse kind=regex` statement that works in a Log Analytics or Sentinel query might not populate any fields when used in a transformation.
>
> To make a `parse kind=regex` statement work in a transformation, ensure the pattern accounts for the full input string. Add a trailing matcher after the last captured column so that the expression extends to the end of the line. For example, appending `@'\sby' *` to the pattern extends the match past the last field and enforces a full-line match:
>
> ```kusto
> source
> | parse kind=regex SyslogMessage with @'^%FTD-4-106023:\s+Deny\s+' Protocol: string @'\s+src\s+' SrcInterface: string @':' SrcIP: string @'\/' SrcPort: long @'\s+dst\s+' DstInterface: string @':' DstIP: string @'\/' DstPort: long @'\sby' *
> ```
>
> Alternatively, convert the statement to pure regex parsing with the `parse` operator, which also enforces a full-line match in transformations.

### Parse-kv operator

Use the [parse-kv](/kusto/query/parse-kv-operator?view=azure-monitor&preserve-view=true) operator to extract named, typed fields from key/value text. For example, extract addresses, byte counts, and actions from a network log. The operator adds the declared columns to the input row; it doesn't create a dynamic property bag.

`parse-kv` supports specified delimiters, unspecified delimiters, and regular expressions. When you specify delimiters, `pair_delimiter` separates pairs and `kv_delimiter` separates a key from its value. Use `quote` and `escape` for quoted or escaped values. Use `greedy=true` when an unquoted value contains pair delimiters and should continue until the next key.

In transformations, the following limits and restrictions apply:

* Use at most three `parse-kv` invocations per query and at most 100 declared keys per invocation.
* Write option values directly as literals in `with (...)`. For example, use `pair_delimiter=','`, not a reference to a `let` variable containing `','`. This restriction applies to `pair_delimiter`, `kv_delimiter`, `quote`, `escape`, `regex`, and `greedy`.
* Declare each output key only once. Duplicate declarations, such as `(key:string, key:string)`, cause a validation error.
* The `decimal` output type isn't supported. Use `string` to preserve the text, or `real` when binary floating-point precision is acceptable.

Only declared keys are extracted. A missing string value produces an empty string. A missing or invalid value for a supported non-string conversion produces null for that column without clearing the other parsed columns.

#### Example: Extract fields from a network log

The following transformation extracts fields from a string column named `Message` and retains the original text:

```kusto
source
| parse-kv Message as (src:string, dst:string, bytes:long, action:string)
    with (pair_delimiter=' ', kv_delimiter='=', quote='"')
| project TimeGenerated, Message, src, dst, bytes, action
```

For `Message` containing `src=10.1.2.3 dst=198.51.100.8 bytes=125 action="connection denied"`, the extracted values are:

| src | dst | bytes | action |
| --- | --- | --- | --- |
| 10.1.2.3 | 198.51.100.8 | 125 | connection denied |

The input stream must expose `TimeGenerated` as `datetime` and `Message` as `string`. The destination table must also have `src`, `dst`, and `action` as `string` columns and `bytes` as a `long` column.

#### Repeated keys and empty values

A repeated key in the input text isn't the same as a duplicate declaration in `as (...)`. Selection of repeated input values depends on the extraction mode:

| Configuration | Selection behavior |
| --- | --- |
| Delimiter mode without `escape` | Selects the first nonempty value. For `key=,key=two` with comma-separated pairs, the result is `two`. |
| Delimiter mode with `escape` | An empty value before a pair delimiter can be selected and stop the search. For the same input with `escape=@'\'`, the result is an empty string. |
| Regex mode | Selects the last nonempty captured value. A later empty or unmatched value capture doesn't erase an earlier nonempty value. |

#### Regex considerations

In regex mode, provide exactly two capturing groups: the first for the key and the second for its value. Use noncapturing groups, such as `(?:...)`, for additional grouping.

For example, this query extracts two fields from semicolon-separated text:

```kusto
print Message='src:10.1.2.3; action:deny'
| parse-kv Message as (src:string, action:string)
    with (regex=@'([a-z]+):([^;]+)')
| project src, action
```

The result is `src` equal to `10.1.2.3` and `action` equal to `deny`.

> [!IMPORTANT]
> In transformations, `parse-kv` regex extraction searches the remaining input after each match. Start anchors such as `^` and `\A` can match again at a resumed search position, and word boundaries such as `\b` can't inspect the character before that position. Results can differ from queries against stored data. Avoid anchors and boundary assertions that depend on earlier text; use explicit delimiters when possible.

For example, parsing `key=firstkey=second` with `regex='^(key)=(first|second)'` returns `second` in a transformation, rather than `first`. Also avoid declaring an empty key name when the key capture group is optional: an unmatched key capture can be treated as a captured empty key.

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

### Bag functions

Use bag functions to retain optional attributes, remove unwanted top-level fields, or combine normalized and source-specific properties. The functions operate on each record independently and return a `dynamic` value.

#### pack_all()

The [pack_all()](/kusto/query/pack-all-function?view=azure-monitor&preserve-view=true) function collects the current row's columns into a property bag. Use `pack_all(true)` to exclude null or empty column values. The default, `pack_all()`, includes them.

Packing doesn't remove the original columns from the output or change the input stream or destination table schema. Use `project` to select the output columns, and store the bag in a `dynamic` column. Only columns available at the point where you call the function are packed, including columns added by earlier transformation steps. Property order isn't guaranteed.

#### bag_remove_keys()

The [bag_remove_keys()](/kusto/query/bag-remove-keys-function?view=azure-monitor&preserve-view=true) function removes specified keys and their values from a property bag:

```kusto
bag_remove_keys(bag, keys)
```

Pass a property bag as `bag` and a dynamic array of property names as `keys`.

> [!IMPORTANT]
> In transformations, `bag_remove_keys()` removes only exact top-level property names. It doesn't traverse nested JSONPath expressions such as `$.context.debug` or support wildcard or array-index expressions. To remove an entire nested object or array, specify its top-level property name.

If `keys` isn't an array, the bag contents are returned unchanged. Non-string entries in the array are ignored, as are names that aren't present in the bag. If `bag` isn't a property bag, the result is null. Always pass an array of strings rather than relying on implicit conversion.

#### Example: Pack optional attributes

The following transformation keeps `TimeGenerated` and `Message` as separate columns and collects other populated columns in `Attributes`:

```kusto
source
| extend Attributes = bag_remove_keys(
    pack_all(true),
    parse_json('["TimeGenerated","Message"]'))
| project TimeGenerated, Message, Attributes
```

For an input row with `HostName` equal to `server01`, `RequestCount` equal to `3`, and `OptionalText` equal to an empty string, the resulting attributes are:

```json
{"HostName":"server01","RequestCount":3}
```

The input stream must expose these fields as columns. The destination table must have `TimeGenerated` of type `datetime`, `Message` of type `string`, and `Attributes` of type `dynamic`. This pattern doesn't capture fields that aren't available to the transformation.

#### bag_merge()

The [bag_merge()](/kusto/query/bag-merge-function?view=azure-monitor&preserve-view=true) function combines between two and 64 property bags:

```kusto
bag_merge(bag1, bag2, ...)
```

When a key appears in more than one bag, the leftmost value wins. Merging is shallow: a winning nested object or array is retained as a whole, not recursively combined with another value.

```kusto
print Attributes = bag_merge(
    parse_json('{"severity":"high","context":{"source":"parser"}}'),
    parse_json('{"severity":"low","context":{"vendor":"Contoso"},"action":"deny"}'))
```

The result is:

```json
{"severity":"high","context":{"source":"parser"},"action":"deny"}
```

Unlike Azure Data Explorer, transformations accept statically scalar arguments such as `42` and ignore them after converting them to dynamic values. For example, `bag_merge(42, parse_json('{"a":1}'))` returns `{"a":1}`. Pass actual property bags. To retain a scalar as a property, wrap it with `pack()`, such as `pack('value', 42)`.

### Hexadecimal conversion

Use [tohex()](/kusto/query/tohex-function?view=azure-monitor&preserve-view=true) to convert an `int` or `long` value to a hexadecimal string:

```kusto
tohex(value, minLength)
```

`minLength` is optional and specifies a minimum zero-padded width, not a maximum output length. For example, `tohex(256, 8)` returns `"00000100"`, while `tohex(256, 2)` returns `"100"`. Use a width from 1 to 16; larger widths are limited to 16.

The following transformation-specific rules apply:

* Both arguments must be statically typed as `int` or `long`. Explicitly convert other types with `toint()` or `tolong()`. For example, `tohex(true)` is rejected, but `tohex(toint(true))` returns `"1"`.
* An explicit null minimum width returns an empty string. It isn't equivalent to omitting the argument.
* Negative values retain their original integer width. `tohex(int(-1), 16)` returns `"00000000ffffffff"`, while `tohex(long(-1), 16)` returns `"ffffffffffffffff"`. Convert to `long` explicitly when you need a sign-extended 64-bit result.

These rules apply consistently to constants and column values in transformations. Azure Data Explorer can produce different results for null widths and negative `int` values depending on the query's execution path.

### IP parsing and classification

Use the following functions to normalize IP addresses and annotate network events. IP arguments must be strings; explicitly convert dynamic properties with `tostring()` when needed.

| Function | Use | Invalid input result in transformations |
| --- | --- | --- |
| [parse_ipv4(ip)](/kusto/query/parse-ipv4-function?view=azure-monitor&preserve-view=true) | Converts IPv4 text to a nonnegative number stored as a `long`, in big-endian order. A CIDR suffix clears host bits. | Null. |
| [parse_ipv6(ip)](/kusto/query/parse-ipv6-function?view=azure-monitor&preserve-view=true) | Converts IPv6 or IPv4 text to an expanded, lowercase IPv6 string. IPv4 becomes IPv4-mapped IPv6. A CIDR suffix clears host bits. | Empty string. |
| [ipv4_is_match(ip1, ip2, prefix)](/kusto/query/ipv4-is-match-function?view=azure-monitor&preserve-view=true) | Compares IPv4 addresses using their embedded prefixes and the optional integer `prefix`. | False, including when the optional prefix is explicitly null. |
| [ipv4_is_private(ip)](/kusto/query/ipv4-is-private-function?view=azure-monitor&preserve-view=true) | Checks whether the masked network base belongs to an RFC1918 private range. | Null. |
| [ipv4_is_in_range(address, range)](/kusto/query/ipv4-is-in-range-function?view=azure-monitor&preserve-view=true) | Checks whether the address or entire source subnet fits within one target IPv4 network. | Null if either argument can't be parsed. |

> [!IMPORTANT]
> In transformations, `ipv4_is_match()` returns false when an address can't be parsed, rather than the null result described in the general KQL reference. A false result alone doesn't distinguish an invalid address from a valid nonmatch. Use `parse_ipv4()` separately when you need to check address validity.

Keep the following distinctions in mind:

* `parse_ipv4()` returns a `long`, not an `int`. For example, `parse_ipv4('192.168.1.1')` returns `3232235777`; adding `/24` returns `3232235776`. Dotted netmask suffixes aren't supported by `parse_ipv4()`.
* `parse_ipv6('192.168.255.255')` returns `0000:0000:0000:0000:0000:ffff:c0a8:ffff`. Its empty-string failure result differs from the null returned by `parse_ipv4()`.
* For `ipv4_is_match()`, the shortest prefix among both addresses and the optional `int` or `long` prefix determines the comparison. An omitted prefix acts as 32. For example, `ipv4_is_match('192.168.1.1/24', '192.168.1.255', 32)` returns true because the embedded `/24` still applies. Use optional prefix values from 0 to 32.
* `ipv4_is_private()` checks only `10.0.0.0/8`, `172.16.0.0/12`, and `192.168.0.0/16`. Loopback and link-local addresses aren't RFC1918 private addresses. For example, `ipv4_is_private('127.0.0.1')` returns false. Private doesn't mean trusted, and nonprivate doesn't necessarily mean publicly routable.
* Prefixes affect private classification: `ipv4_is_private('192.168.1.1/8')` returns false because the masked base is `192.0.0.0`. Use a host address without a broad prefix when you want to classify that host.
* `ipv4_is_in_range()` accepts one target network string, not an array or comma-separated list. `ipv4_is_in_any_range()` is a separate function and isn't supported in transformations.
* When the source includes a prefix, `ipv4_is_in_range()` checks whole-subnet containment. For example, `ipv4_is_in_range('10.1.2.3/8', '10.1.0.0/16')` returns false because the entire `/8` doesn't fit within the `/16`, even though the written host address does.

#### Example: Annotate an IPv4 network event

The following transformation retains the original address and adds numeric and network-classification fields without filtering records:

```kusto
source
| extend
    SourceIPv4Number = parse_ipv4(SourceIp),
    SourceIsRfc1918 = ipv4_is_private(SourceIp),
    InCorporateRange = ipv4_is_in_range(SourceIp, '10.20.0.0/16')
| project TimeGenerated, SourceIp, SourceIPv4Number, SourceIsRfc1918, InCorporateRange
```

For `SourceIp` equal to `10.20.1.4`, `SourceIPv4Number` is `169083140` and both Boolean fields are true. For `SourceIp` equal to `invalid`, all three added fields are null.

The input stream must expose `TimeGenerated` as `datetime` and `SourceIp` as `string`. The destination must also have `SourceIPv4Number` as `long` and the two classification columns as `boolean`. Retain the original address if you need to investigate parsing failures or preserve host bits removed by a CIDR prefix.

## Related content

- [Create a data collection rule](../vm/data-collection.md) and an association to it from a virtual machine using the Azure Monitor agent.
