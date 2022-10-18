type KeyOfMap<M extends Map<unknown, unknown>> = M extends Map<infer K, unknown> ? K : never

export function Roll<T extends Map<unknown, unknown>>(lootTable: T): KeyOfMap<T>
export function AdjustWeights<T>(lootTable: T, luck: number, callback?: (dropId: number) => boolean): T