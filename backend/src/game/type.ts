/**
 * Lifecycle:
 * - Initialize: When the application is started
 */
/**
 * property = baseProperty + growProperty * level
 */
export interface Elf<
  Attribute = any
> {
  /** The register name. */
  name: string
  baseHealth: number
  baseDamage: number
  basePower: number
  /** For physical damage. */
  baseArmor: number
  /** For magical damage. */
  baseResistance: number
  /** How fast. */
  baseSpeed: number
  growHealth: number
  growDamage: number
  growPower: number
  growArmor: number
  growResistance: number
  growSpeed: number
  /** E.g.: Fire, Water. */
  attribute: Attribute | Attribute[]
}

interface Ability {
  /** The register name. */
  name: string
  validateCall: (ctx: any) => boolean
  call: (ctx: any) => void
}
