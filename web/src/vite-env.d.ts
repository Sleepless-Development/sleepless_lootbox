/// <reference types="vite/client" />

// SVG imports
declare module "*.svg" {
    const content: string;
    export default content;
}

// Image imports
declare module "*.png" {
    const content: string;
    export default content;
}

declare module "*.jpg" {
    const content: string;
    export default content;
}

declare module "*.jpeg" {
    const content: string;
    export default content;
}

declare module "*.gif" {
    const content: string;
    export default content;
}

declare module "*.webp" {
    const content: string;
    export default content;
}

// CSS modules
declare module "*.module.css" {
    const classes: { [key: string]: string };
    export default classes;
}

declare module "*.module.scss" {
    const classes: { [key: string]: string };
    export default classes;
}
