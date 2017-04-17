//
//  Types.swift
//  cc_swift
//
//  Created by Rip Britton on 3/9/17.
//
//

import Foundation

class Types {
    static let DamageStrings = ["Bludgeoning", "Piercing", "Slashing", "Acid", "Cold", "Fire", "Force", "Lightning", "Necrotic", "Poison", "Psychic", "Radiant", "Thunder"]
    
    static let AbilitiesStrings = ["STR", "DEX", "CON", "INT", "WIS", "CHA"]
    
    static let SkillsStrings = ["Acrobatics", "Animal Handling", "Arcana", "Athletics", "Deception", "History", "Insight", "Intimidation", "Investigation", "Medicine", "Nature", "Perception", "Performance", "Persuasion", "Religion", "Sleight of Hand", "Stealth", "Survival"]
    
    static let ClassStrings = ["Barbarian", "Bard", "Cleric", "Druid", "Fighter", "Monk", "Paladin", "Ranger", "Rogue", "Sorcerer", "Warlock", "Wizard", "Custom"]
    
    static let levels = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20]
    
    static let BackgroundStrings = ["Acolyte", "Charlatan", "Criminal", "Entertainer", "Folk Hero", "Guild Artisan", "Hermit", "Noble", "Outlander", "Sage", "Sailor", "Soldier", "Urchin", "Custom"]
    
    static let RaceStrings = ["Aarakocra", "Aasimar", "Dragonborn", "Dwarf", "Elf", "Genasi", "Gnome", "Goliath", "Half-Elf", "Halfling", "Half-Orc", "Human", "Tiefling", "Custom"]
    
    static let SubraceToRaceDictionary: [String: Array] = [
        "Aarakocra":[],
        "Aasimar":[],
        "Dragonborn":[],
        "Dwarf":["Dark", "Hill", "Mountain"],
        "Elf":["Dark", "Eladrin", "High", "Wood"],
        "Genasi":["Air", "Earth", "Fire", "Water"],
        "Gnome":["Deep", "Forest", "Rock"],
        "Goliath":[],
        "Half-Elf":["Half-Elf", "Variant"],
        "Halfling":["Ghastly", "Lightfoot", "Stout"],
        "Half-Orc":[],
        "Human":["Human", "Variant"],
        "Tiefling":["Tiefling", "Variant"],
        "Custom":[]
    ]
    
    static let SkillToAbilityDictionary: [String: String] =  [
        "Acrobatics": "DEX",
        "Animal Handling": "WIS",
        "Arcana":"INT",
        "Athletics": "STR",
        "Deception": "CHA",
        "History": "INT",
        "Insight": "WIS",
        "Intimidation": "CHA",
        "Investigation": "INT",
        "Medicine": "WIS",
        "Nature": "INT",
        "Perception": "WIS",
        "Performance": "CHA",
        "Persuasion": "CHA",
        "Religion": "INT",
        "Sleight of Hand": "DEX",
        "Stealth": "DEX",
        "Survival" : "WIS"]
    
    enum Damage: String {
        case Bludgeoning = "Bludgeoning"
        case Piercing = "Piercing"
        case Slashing = "Slashing"
        case Acid = "Acid"
        case Cold = "Cold"
        case Fire = "Fire"
        case Force = "Force"
        case Lightning = "Lightning"
        case Necrotic = "Necrotic"
        case Poison = "Poison"
        case Psychic = "Psychic"
        case Radiant = "Radiant"
        case Thunder = "Thunder"
    }
    
    enum Abilities: String {
        case STR = "STR"
        case DEX = "DEX"
        case CON = "CON"
        case INT = "INT"
        case WIS = "WIS"
        case CHA = "CHA"
    }
    
    enum AbilitiesFullName: String {
        case STR = "Strength"
        case DEX = "Dexterity"
        case CON = "Constitution"
        case INT = "Intelligence"
        case WIS = "Wisdom"
        case CHA = "Charisma"
    }
    
    enum Skills: String {
        case Acrobatics = "Acrobatics"
        case Animal_Handling = "Animal Handling"
        case Arcana = "Arcana"
        case Athletics = "Athletics"
        case Deception = "Deception"
        case History = "History"
        case Insight = "Insight"
        case Intimidation = "Intimidation"
        case Investigation = "Investigation"
        case Medicine = "Medicine"
        case Nature = "Nature"
        case Perception = "Perception"
        case Performance = "Performance"
        case Persuasion = "Persuasion"
        case Religion = "Religion"
        case Sleight_of_Hand = "Sleight of Hand"
        case Stealth = "Stealth"
        case Survival = "Survival"
    }
    
    enum Classes: String {
        case Barbarian = "Barbarian"
        case Bard = "Bard"
        case Cleric = "Cleric"
        case Druid = "Druid"
        case Fighter = "Fighter"
        case Monk = "Monk"
        case Paladin = "Paladin"
        case Ranger = "Ranger"
        case Rogue = "Rogue"
        case Sorcerer = "Sorcerer"
        case Warlock = "Warlock"
        case Wizard = "Wizard"
        case Custom = "Custom"
    }

}
