# Conversions for `common-web/check.ts`

## `export interface Checkable<T>`

This is redundant and won't be converted.

This is pretty much doing the job of `Codable`.

## `export interface Def<T>`

This is redundant and won't be converted.

## `export const is = <T>(obj: unknown, def: Checkable<T>): obj is T`

This is redundant and won't be converted. We can use the `is` operator in Swift instead.

## `export const create = <T>(def: Checkable<T>) => (v: unknown): v is T`

This may be converted, but for right now, it will be left alone.

## `export const assure = <T>(def: Checkable<T>, obj: unknown): T`

This is redundant and won't be converted. If we convert this, it would probably be akin to `as!`, which is unsafe. Instead, we can use `guard`, then throw an
error if it's not the proper type.

## `export const isObject = (obj: unknown): obj is Record<string, unknown>`

This is redundant and won't be converted. We can use the `is` operator in Swift instead. `Record<string, unknown>` appears to be a Dictionary, so we will use
that instead.
