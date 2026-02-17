import React from "react";
import { RollItem, getRarityColor, getRarityGradient } from "../../types";
import { formatChance } from "../../utils/misc";
import styles from "./index.module.css";

interface ItemCardProps {
    item: RollItem;
    showChance?: boolean;
    highlighted?: boolean;
    size?: "small" | "normal" | "large";
    onClick?: () => void;
}

const ItemCard: React.FC<ItemCardProps> = ({ item, showChance = false, highlighted = false, size = "normal", onClick }) => {
    const rarityColor = getRarityColor(item);
    const rarityGradient = getRarityGradient(item);

    const cardClasses = [styles.card, size === "small" && styles.small, size === "large" && styles.large, highlighted && styles.highlighted, onClick && styles.clickable].filter(Boolean).join(" ");

    return (
        <div
            className={cardClasses}
            style={
                {
                    "--rarity-color": rarityColor,
                    borderColor: highlighted ? rarityColor : undefined,
                } as React.CSSProperties
            }
            onClick={onClick}
        >
            {/* Rarity Glow Background */}
            <div className={styles.glow} style={{ background: rarityGradient }} />

            {/* Item Image */}
            <div className={styles.imageContainer}>
                <img
                    className={styles.image}
                    src={item.image}
                    alt={item.label}
                    onError={(e) => {
                        (e.target as HTMLImageElement).src = "https://via.placeholder.com/100?text=?";
                    }}
                />
                {/* Amount Badge */}
                {item.amount > 1 && <span className={styles.amount}>x{item.amount}</span>}
            </div>

            {/* Item Info */}
            <div className={styles.info}>
                <span className={styles.label} title={item.label}>
                    {item.label}
                </span>
            </div>

            {/* Chance Display */}
            {showChance && (
                <div className={styles.chance} style={{ color: rarityColor }}>
                    {formatChance(item.chance)}
                </div>
            )}

            {/* Rarity Badge */}
            <div className={styles.rarity} style={{ backgroundColor: rarityColor }}>
                {item.rarity.charAt(0).toUpperCase()}
            </div>

            {/* Highlight Effect */}
            {highlighted && <div className={styles.highlightEffect} />}
        </div>
    );
};

export default ItemCard;
