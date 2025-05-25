# Conversion for `common-web/ipld.ts`

## `export type JsonValue`

This type has been converted.

We are using an `enum` for this.

## `export type IpldValue`

This type has been converted.

We are using an `enum` for this.

## `export const jsonToIpld = (val: JsonValue): IpldValue`

This type has been converted. It is also used in the custom `Decodable` method.

## `export const ipldToJson = (val: IpldValue): JsonValue`

This type has been converted. It is also used in the custom `Encodable` method.

## `export const ipldEquals = (a: IpldValue, b: IpldValue): boolean`

This is redundant and will not be converted. The `enum` that contains these objects, including the objects themselves, will conform to `Equatable` instead.
