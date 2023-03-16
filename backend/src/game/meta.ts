/**
 * Lifecycle: It's for persistence. immutable during battle.
 */
import { Elf as ElfType } from "./type.js"

class Player {

}

export class Elf {
  type: ElfType
  /** Custom name. */
  name: string
  level: number
  get stdHealth(): number {
    return this.type.baseHealth + this.level * this.type.growHealth
  }

  get stdDamage(): number {
    return this.type.baseDamage + this.level * this.type.growDamage
  }

  get stdPower(): number {
    return this.type.basePower + this.level * this.type.growPower
  }

  get stdArmor(): number {
    return this.type.baseArmor + this.level * this.type.growArmor
  }

  get stdResistance(): number {
    return this.type.baseResistance + this.level * this.type.growResistance
  }

  get stdSpeed(): number {
    return this.type.baseSpeed + this.level * this.type.growSpeed
  }
}
