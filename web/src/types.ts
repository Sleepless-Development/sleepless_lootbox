export type Rarity = "common" | "uncommon" | "rare" | "epic" | "legendary";

export interface RollItem {
    name: string;
    label: string;
    amount: number;
    image: string;
    rarity: Rarity;
    rarityColor: string;
    rarityLabel: string;
    weight: number;
    chance: number;
    metadata?: Record<string, unknown>;
}

export interface RollData {
    pool: RollItem[];
    winnerIndex: number;
    caseName: string;
    caseLabel: string;
}

export interface PreviewData {
    caseName: string;
    caseLabel: string;
    caseImage?: string;
    description?: string;
    items: RollItem[];
}

export interface RarityConfig {
    label: string;
    color: string;
}

// Fallback colors in case rarityColor is not provided by server
const FALLBACK_COLORS: Record<Rarity, string> = {
    common: "#94999a",
    uncommon: "#26c057",
    rare: "#0aa7e6",
    epic: "#d02e9b",
    legendary: "#ffc500",
};

const FALLBACK_LABELS: Record<Rarity, string> = {
    common: "Common",
    uncommon: "Uncommon",
    rare: "Rare",
    epic: "Epic",
    legendary: "Legendary",
};

export const getRarityColor = (itemOrRarity: RollItem | Rarity): string => {
    if (typeof itemOrRarity === "string") {
        return FALLBACK_COLORS[itemOrRarity] || FALLBACK_COLORS.common;
    }
    return itemOrRarity.rarityColor || FALLBACK_COLORS[itemOrRarity.rarity] || FALLBACK_COLORS.common;
};

export const getRarityLabel = (item: RollItem): string => {
    return item.rarityLabel || FALLBACK_LABELS[item.rarity] || item.rarity;
};

export const getRarityGradient = (item: RollItem): string => {
    const color = getRarityColor(item);
    return `linear-gradient(0deg, ${color}66 0%, transparent 60%)`;
};

// Legacy exports for backwards compatibility (deprecated)
export const RARITY_COLORS: Record<Rarity, RarityConfig> = {
    common: { label: "Common", color: "#94999a" },
    uncommon: { label: "Uncommon", color: "#26c057" },
    rare: { label: "Rare", color: "#0aa7e6" },
    epic: { label: "Epic", color: "#d02e9b" },
    legendary: { label: "Legendary", color: "#ffc500" },
};
