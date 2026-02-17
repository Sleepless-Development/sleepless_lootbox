import React, { useEffect, useState, useRef } from "react";
import { RollItem } from "../../types";
import ItemCard from "../ItemCard";
import styles from "./index.module.css";
import rollSound from "../../assets/roll.mp3";

interface RollerProps {
    pool: RollItem[];
    winnerIndex: number;
    caseLabel: string;
    onComplete: (winner: RollItem) => void;
}

const Roller: React.FC<RollerProps> = ({ pool, winnerIndex, caseLabel, onComplete }) => {
    const [isRolling, setIsRolling] = useState(false);
    const [translateX, setTranslateX] = useState(0);
    const [showWinHighlight, setShowWinHighlight] = useState(false);
    const [displayWinnerIndex, setDisplayWinnerIndex] = useState(winnerIndex);

    const rollerRef = useRef<HTMLDivElement>(null);
    const viewportRef = useRef<HTMLDivElement>(null);
    const rollAudioRef = useRef<HTMLAudioElement | null>(null);
    const hasCompletedRef = useRef(false);
    const actualWinnerIndexRef = useRef(winnerIndex);

    const CARD_WIDTH = 120;
    const CARD_GAP = 12;
    const CARD_TOTAL = CARD_WIDTH + CARD_GAP;
    const REPEAT_COUNT = 5; // Repeat pool this many times for infinite effect

    // Create extended pool by repeating items
    const extendedPool = React.useMemo(() => {
        const repeated: RollItem[] = [];
        for (let i = 0; i < REPEAT_COUNT; i++) {
            repeated.push(...pool);
        }
        return repeated;
    }, [pool]);

    // Adjust winner index to be in the middle section of repeated items
    // This ensures we always have items on both sides
    const adjustedWinnerIndex = React.useMemo(() => {
        const middleRepeat = Math.floor(REPEAT_COUNT / 2);
        return middleRepeat * pool.length + winnerIndex;
    }, [pool.length, winnerIndex]);

    // Store winner index in ref for use in completion callback
    actualWinnerIndexRef.current = winnerIndex; // Keep original for reporting correct item

    // Start the roll animation
    useEffect(() => {
        if (pool.length === 0) return;

        // Reset state for new roll
        hasCompletedRef.current = false;
        setShowWinHighlight(false);
        setDisplayWinnerIndex(adjustedWinnerIndex);
        setTranslateX(0);
        setIsRolling(false);

        // Small delay to ensure UI is ready
        const startDelay = setTimeout(() => {
            // Get the actual viewport width
            const viewportWidth = viewportRef.current?.offsetWidth || 900;
            const viewportCenter = viewportWidth / 2;

            // Calculate position: we want the winning card's center at the viewport center
            // Use adjustedWinnerIndex which is in the middle of the repeated pool
            const cardCenterPosition = adjustedWinnerIndex * CARD_TOTAL + CARD_WIDTH / 2;
            const scrollPosition = cardCenterPosition - viewportCenter;

            setIsRolling(true);
            setTranslateX(scrollPosition);

            // Play roll sound
            if (rollAudioRef.current) {
                rollAudioRef.current.currentTime = 0;
                rollAudioRef.current.play().catch(() => {});
            }
        }, 100);

        return () => clearTimeout(startDelay);
    }, [pool, winnerIndex, adjustedWinnerIndex, CARD_TOTAL, CARD_WIDTH]);

    // Handle roll completion
    useEffect(() => {
        if (!isRolling || hasCompletedRef.current) return;

        const completionTimer = setTimeout(() => {
            if (hasCompletedRef.current) return;
            hasCompletedRef.current = true;

            const winnerIdx = actualWinnerIndexRef.current;

            setDisplayWinnerIndex(winnerIdx);
            setShowWinHighlight(true);

            // Stop roll sound
            if (rollAudioRef.current) {
                rollAudioRef.current.pause();
            }

            // Small delay before notifying parent
            setTimeout(() => {
                const winner = pool[winnerIdx];
                if (winner) {
                    onComplete(winner);
                }
            }, 100);
        }, 5000);

        return () => clearTimeout(completionTimer);
    }, [isRolling, pool, onComplete]);

    const trackClasses = [styles.track, isRolling && styles.trackRolling].filter(Boolean).join(" ");

    return (
        <div className={styles.container}>
            {/* Case Label */}
            <div className={styles.header}>
                <h2 className={styles.title}>{caseLabel}</h2>
                <p className={styles.subtitle}>Opening...</p>
            </div>

            {/* Main Roller */}
            <div className={styles.viewport} ref={viewportRef}>
                {/* Center Marker */}
                <div className={styles.marker} />
                <div className={styles.markerGlow} />

                {/* Edge Fades */}
                <div className={`${styles.fade} ${styles.fadeLeft}`} />
                <div className={`${styles.fade} ${styles.fadeRight}`} />

                {/* Scrolling Track */}
                <div
                    ref={rollerRef}
                    className={trackClasses}
                    style={{
                        // Simply translate left by the scroll position
                        transform: `translateX(${-translateX}px)`,
                        transitionDuration: `5000ms`,
                    }}
                >
                    {extendedPool.map((item, index) => {
                        const isWinner = showWinHighlight && index === displayWinnerIndex;
                        const itemClasses = [styles.item, isWinner && styles.itemWinner].filter(Boolean).join(" ");

                        return (
                            <div key={`${item.name}-${index}-${Math.floor(index / pool.length)}`} className={itemClasses}>
                                <ItemCard item={item} showChance={false} highlighted={isWinner} />
                            </div>
                        );
                    })}
                </div>
            </div>

            {/* Hidden Audio Element */}
            <audio ref={rollAudioRef} src={rollSound} preload="auto" />
        </div>
    );
};

export default Roller;
