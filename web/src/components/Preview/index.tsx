import React, { useMemo } from "react";
import { PreviewData, RollItem, getRarityColor, RARITY_COLORS, Rarity } from "../../types";
import { formatChance } from "../../utils/misc";
import ItemCard from "../ItemCard";
import styles from "./index.module.css";

interface PreviewProps {
    data: PreviewData;
    onClose: () => void;
}

const RARITY_ORDER: Rarity[] = ["legendary", "epic", "rare", "uncommon", "common"];

const Preview: React.FC<PreviewProps> = ({ data, onClose }) => {
    // Group items by rarity
    const groupedItems = useMemo(() => {
        const groups: Record<Rarity, RollItem[]> = {
            common: [],
            uncommon: [],
            rare: [],
            epic: [],
            legendary: [],
        };

        data.items.forEach((item) => {
            if (groups[item.rarity]) {
                groups[item.rarity].push(item);
            } else {
                groups.common.push(item);
            }
        });

        // Sort each group by chance (descending)
        Object.keys(groups).forEach((rarity) => {
            groups[rarity as Rarity].sort((a, b) => b.chance - a.chance);
        });

        return groups;
    }, [data.items]);

    // Calculate total items and best odds
    const stats = useMemo(() => {
        const totalItems = data.items.length;
        const bestItem = data.items.reduce((best, item) => (item.chance < best.chance ? item : best), data.items[0]);

        return { totalItems, bestItem };
    }, [data.items]);

    return (
        <div className={styles.overlay} onClick={onClose}>
            <div className={styles.container} onClick={(e) => e.stopPropagation()}>
                {/* Header */}
                <div className={styles.header}>
                    <div className={styles.headerContent}>
                        {data.caseImage && (
                            <img
                                className={styles.caseImage}
                                src={data.caseImage}
                                alt={data.caseLabel}
                                onError={(e) => {
                                    (e.target as HTMLImageElement).style.display = "none";
                                }}
                            />
                        )}
                        <div className={styles.headerText}>
                            <h2 className={styles.title}>{data.caseLabel}</h2>
                            {data.description && <p className={styles.description}>{data.description}</p>}
                        </div>
                    </div>

                    <button className={styles.closeBtn} onClick={onClose}>
                        <span>×</span>
                    </button>
                </div>

                {/* Stats Bar */}
                <div className={styles.stats}>
                    <div className={styles.stat}>
                        <span className={styles.statValue}>{stats.totalItems}</span>
                        <span className={styles.statLabel}>Total Items</span>
                    </div>
                    {stats.bestItem && (
                        <div className={styles.stat}>
                            <span className={styles.statValue} style={{ color: getRarityColor(stats.bestItem.rarity) }}>
                                {formatChance(stats.bestItem.chance)}
                            </span>
                            <span className={styles.statLabel}>Best Drop</span>
                        </div>
                    )}
                </div>

                {/* Content */}
                <div className={styles.content}>
                    {RARITY_ORDER.map((rarity) => {
                        const items = groupedItems[rarity];
                        if (items.length === 0) return null;

                        const rarityColor = getRarityColor(rarity);
                        const rarityLabel = RARITY_COLORS[rarity]?.label || rarity;

                        return (
                            <div key={rarity} className={styles.section}>
                                <div className={styles.sectionHeader}>
                                    <div className={styles.sectionIndicator} style={{ backgroundColor: rarityColor }} />
                                    <h3 className={styles.sectionTitle} style={{ color: rarityColor }}>
                                        {rarityLabel}
                                    </h3>
                                    <span className={styles.sectionCount}>
                                        {items.length} item{items.length !== 1 ? "s" : ""}
                                    </span>
                                </div>

                                <div className={styles.sectionItems}>
                                    {items.map((item, index) => (
                                        <div key={`${item.name}-${index}`} className={styles.itemWrapper}>
                                            <ItemCard item={item} showChance={true} size="normal" />
                                        </div>
                                    ))}
                                </div>
                            </div>
                        );
                    })}
                </div>

                {/* Footer */}
                <div className={styles.footer}>
                    <p className={styles.footerText}>Chances shown are approximate and based on item weights</p>
                    <button className={styles.actionBtn} onClick={onClose}>
                        Close Preview
                    </button>
                </div>
            </div>
        </div>
    );
};

export default Preview;
