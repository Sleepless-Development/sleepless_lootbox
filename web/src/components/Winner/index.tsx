import React, { useEffect, useRef } from "react";
import { RollItem } from "../../types";
import ItemCard from "../ItemCard";
import styles from "./index.module.css";
import winnerSound from "../../assets/winner.mp3";

interface WinnerProps {
    item: RollItem;
    onClose: () => void;
}

const Winner: React.FC<WinnerProps> = ({ item, onClose }) => {
    const audioRef = useRef<HTMLAudioElement | null>(null);

    // Play winner sound on mount
    useEffect(() => {
        if (audioRef.current) {
            audioRef.current.currentTime = 0;
            audioRef.current.play().catch(() => {});
        }
    }, []);

    // Auto-close after 3 seconds
    useEffect(() => {
        const timer = setTimeout(() => {
            onClose();
        }, 3000);

        return () => clearTimeout(timer);
    }, [onClose]);

    return (
        <div className={styles.container}>
            <div className={styles.content}>
                <h2 className={styles.title}>You Won!</h2>
                <div className={styles.cardWrapper}>
                    <ItemCard item={item} size="large" highlighted />
                </div>
            </div>
            <audio ref={audioRef} src={winnerSound} preload="auto" />
        </div>
    );
};

export default Winner;
