# Conversion for `common-web/async.ts`

## `export const readFromGenerator = async <T>(gen: AsyncGenerator<T>, isDone: (last?: T) => Promise<boolean> | boolean, waitFor: Promise<unknown> = Promise.resolve(), maxLength = Number.MAX_SAFE_INTEGER,): Promise<T[]>`

This is redundant and will not be converted. Use `AsyncSequence` instead.

## `export type Deferrable`

This is redundant and will not be converted. Use `CheckedContinuation`, `CheckedThrowingContinuation`, and `withCheckedContinuation` instead.

## `export const createDeferrable = (): Deferrable`

This is redundant and will not be converted.

## `export const createDeferrables = (count: number): Deferrable[]`

This is redundant and will not be converted.

## `export const allComplete = async (deferrables: Deferrable[]): Promise<void>`

This is redundant and will not be converted. Instead, use `await` on the method instead.

## `export class AsyncBuffer<T>`

This is redundant and will not be converted. Use `AsyncStream` instead.

## `export class AsyncBufferFullError extends Error`

This has been converted.

## `export function allFulfilled<T extends readonly unknown[] | []>(promises: T,): Promise<{ -readonly [P in keyof T]: Awaited<T[P]> }>`

This is redundant and will not be converted. Use `withTaskGroup` for parallel `await`s. If an error does happen the first time, simply throw on first error or collect the results.

## `export function allFulfilled<T>(promises: Iterable<T | PromiseLike<T>>,): Promise<Awaited<T>[]>`

This is redundant and will not be converted.

## `export function allFulfilled(promises: Iterable<Promise<unknown>>,): Promise<unknown[]>`

This is redundant and will not be converted.

## `export function handleAllSettledErrors<T extends readonly PromiseSettledResult<unknown>[] | [],>(results: T,)`

This is redundant and will not be converted.

## `export function handleAllSettledErrors<T>(results: PromiseSettledResult<T>[],): T[]`

This is redundant and will not be converted.

## `export function handleAllSettledErrors(results: PromiseSettledResult<unknown>[],): unknown[]`

This is redundant and will not be converted.

## `export function isRejectedResult(result: PromiseSettledResult<unknown>,): result is PromiseRejectedResult`

This is redundant and will not be converted.

## `function extractReason(result: PromiseRejectedResult): unknown`

This is redundant and will not be converted.

## `export function isFulfilledResult<T>(result: PromiseSettledResult<T>,): result is PromiseFulfilledResult<T>`

This is redundant and will not be converted.

## `function extractValue<T>(result: PromiseFulfilledResult<T>): T`

This is redundant and will not be converted.

## `function stringifyReason(reason: unknown): string`

This is redundant and will not be converted.
