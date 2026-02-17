import React, { useState, useCallback, useEffect } from "react";
import { useNuiEvent } from "../hooks/useNuiEvent";
import { fetchNui } from "../utils/fetchNui";
import { debugData } from "../utils/debugData";
import { isEnvBrowser } from "../utils/misc";
import { RollData, PreviewData, RollItem } from "../types";
import Roller from "./Roller";
import Preview from "./Preview";
import Winner from "./Winner";
import styles from "./App.module.css";

// Helper function for generating dummy data (used in browser testing)
const RARITY_DATA = {
    common: { color: "#94999a", label: "Common" },
    uncommon: { color: "#26c057", label: "Uncommon" },
    rare: { color: "#0aa7e6", label: "Rare" },
    epic: { color: "#d02e9b", label: "Epic" },
    legendary: { color: "#ffc500", label: "Legendary" },
};

function generateDummyPool(): RollItem[] {
    const rarities: Array<"common" | "uncommon" | "rare" | "epic" | "legendary"> = ["common", "common", "common", "common", "uncommon", "uncommon", "rare", "epic", "legendary"];

    return Array.from({ length: 100 }, (_, i) => {
        const rarity = rarities[Math.floor(Math.random() * rarities.length)];
        return {
            name: `item_${i}`,
            label: `Test Item ${i + 1}`,
            amount: Math.floor(Math.random() * 5) + 1,
            image: "https://via.placeholder.com/100",
            rarity,
            rarityColor: RARITY_DATA[rarity].color,
            rarityLabel: RARITY_DATA[rarity].label,
            weight: Math.random() * 100,
            chance: Math.random() * 10,
        };
    });
}

// Debug data for browser testing
if (isEnvBrowser()) {
    debugData(
        [
            {
                action: "setVisible",
                data: true,
            },
        ],
        500,
    );
}

type ViewState = "idle" | "rolling" | "winner" | "preview";

const App: React.FC = () => {
    const [visible, setVisible] = useState(false);
    const [viewState, setViewState] = useState<ViewState>("idle");
    const [rollData, setRollData] = useState<RollData | null>(null);
    const [previewData, setPreviewData] = useState<PreviewData | null>(null);
    const [winner, setWinner] = useState<RollItem | null>(null);

    // Handle visibility
    useNuiEvent<boolean>("setVisible", (data) => {
        setVisible(data);
        if (!data) {
            // Reset state when hiding
            setViewState("idle");
            setRollData(null);
            setPreviewData(null);
            setWinner(null);
        }
    });

    // Handle roll start
    useNuiEvent<RollData>("startRoll", (data) => {
        setRollData(data);
        setViewState("rolling");
        setWinner(null);
    });

    // Handle preview
    useNuiEvent<PreviewData>("showPreview", (data) => {
        setPreviewData(data);
        setViewState("preview");
    });

    // Handle close preview
    useNuiEvent("closePreview", () => {
        setPreviewData(null);
        setViewState("idle");
    });

    // Handle reset
    useNuiEvent("reset", () => {
        setViewState("idle");
        setRollData(null);
        setPreviewData(null);
        setWinner(null);
    });

    // Handle roll complete
    const handleRollComplete = useCallback((winnerItem: RollItem) => {
        setWinner(winnerItem);
        setViewState("winner");
        fetchNui("rollComplete", { winner: winnerItem });
    }, []);

    // Handle close
    const handleClose = useCallback(() => {
        if (viewState === "rolling") return; // Don't allow closing during roll

        fetchNui("close");
        setVisible(false);
        setViewState("idle");
        setRollData(null);
        setPreviewData(null);
        setWinner(null);
    }, [viewState]);

    // Handle close preview
    const handleClosePreview = useCallback(() => {
        fetchNui("closePreview");
        setPreviewData(null);
        setViewState("idle");
    }, []);

    // Handle winner acknowledge
    const handleWinnerClose = useCallback(() => {
        handleClose();
    }, [handleClose]);

    // Handle ESC key
    useEffect(() => {
        const handleKeyDown = (e: KeyboardEvent) => {
            if (e.key === "Escape") {
                if (viewState === "preview") {
                    handleClosePreview();
                } else if (viewState !== "rolling") {
                    handleClose();
                }
            }
        };

        window.addEventListener("keydown", handleKeyDown);
        return () => window.removeEventListener("keydown", handleKeyDown);
    }, [viewState, handleClose, handleClosePreview]);

    // Notify ready
    useEffect(() => {
        fetchNui("ready");
    }, []);

    // Debug controls for browser testing
    const renderDebugControls = () => {
        if (!isEnvBrowser()) return null;

        return (
            <div className={styles.debugControls}>
                <button
                    onClick={() => {
                        const pool = generateDummyPool();
                        const winnerIndex = Math.floor(Math.random() * 30) + 70;
                        setRollData({
                            pool,
                            winnerIndex,
                            caseName: "test_case",
                            caseLabel: "Test Case"
                        });
                        setViewState("rolling");
                        setVisible(true);
                    }}
                >
                    Test Roll
                </button>
                <button
                    onClick={() => {
                        const pool = generateDummyPool();
                        setPreviewData({
                            caseName: "test_case",
                            caseLabel: "Test Case",
                            description: "A test case containing various items",
                            items: pool.slice(0, 15),
                        });
                        setViewState("preview");
                        setVisible(true);
                    }}
                >
                    Test Preview
                </button>
                <button onClick={handleClose}>Close</button>
            </div>
        );
    };

    if (!visible) {
        return isEnvBrowser() ? <div className={`${styles.appContainer} ${styles.browserMode}`}>{renderDebugControls()}</div> : null;
    }

    return (
        <div className={styles.appContainer}>
            {isEnvBrowser() && renderDebugControls()}

            <div className={styles.appContent}>
                {viewState === "rolling" && rollData && <Roller pool={rollData.pool} winnerIndex={rollData.winnerIndex} caseLabel={rollData.caseLabel} onComplete={handleRollComplete} />}

                {viewState === "winner" && winner && <Winner item={winner} onClose={handleWinnerClose} />}

                {viewState === "preview" && previewData && <Preview data={previewData} onClose={handleClosePreview} />}
            </div>
        </div>
    );
};

export default App;
