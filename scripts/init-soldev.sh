#!/usr/bin/env bash
# Init the internal/_contracts with sol development toolchain.

set -eux -o pipefail

function initForge() {
    mkdir -p contracts
    forge init --force --no-git --no-commit contracts
}

function initHardHat() {
    echo "init HardHat"
    mkdir -p contracts
    cd contracts
    pnpm init
    pnpm install hardhat
    pnpm hardhat init
    mv -f contracts src
    tsconfig='{
        "compilerOptions": {
            "target": "es2020",
            "module": "commonjs",
            "strict": false,
            "esModuleInterop": true,
            "outDir": "dist",
            "forceConsistentCasingInFileNames": true
        },
        "include": ["./scripts/**/*", "./test/**/*"],
        "files": ["hardhat.config.ts"]
    }'
    echo "$tsconfig" > tsconfig.json

    hardhatconfig='
            import { HardhatUserConfig } from "hardhat/config";
            import "@nomicfoundation/hardhat-toolbox";

            const config: HardhatUserConfig = {
            paths: {
                sources: "./src",
                tests: "./test",
                cache: "./cache",
                artifacts: "./artifacts",
            },
            solidity: {
                version: "0.8.19",
                settings: {
                optimizer: {
                    enabled: true,
                    runs: 200,
                },
                },
            },
            typechain: {
                outDir: "typechain",
                target: "ethers-v5", // Use the ethers-v5 target
            },
            };

            export default config;'
    echo "$tsconfig" > hardhat.config.ts
    cd ..
    make lint
}

read -rp "Init you sol dev tool! Enter 1 for Forge or 2 for HardHat: " choice

case "$choice" in
1)
    initForge
    ;;
2)
    initHardHat
    ;;
*)
    echo "Invalid choice"
    ;;
esac
