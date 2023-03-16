export interface Elf<
  Attribute = any
> {
  /**
   * The register name.
   */
  name: string
  health: number
  damage: number
  power: number
  /**
   * For physical damage.
   */
  armor: number
  /**
   * For magical damage.
   */
  resistance: number
  /**
   * How fast.
   */
  speed: number
  /**
   * E.g.: Fire, Water.
   */
  attribute: Attribute
}
