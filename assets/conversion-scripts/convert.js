#!/usr/bin/env node

/**
 * convert.js - SVG Asset Conversion Script for Palimpsest License
 *
 * This script converts SVG files to PNG, JPG, and TIFF formats using
 * the sharp library. It provides high-quality conversions optimised for
 * web, print, and archival use.
 *
 * Usage:
 *   node convert.js <input.svg>
 *   node convert.js --all
 *   node convert.js --format png --sizes 512,1024 badge.svg
 *
 * Options:
 *   --all                  Convert all SVG files in branding directory
 *   --format <fmt>         Convert to specific format (png|jpg|tiff|all)
 *   --sizes <sizes>        Comma-separated sizes (e.g., 512,1024,2048)
 *   --output <dir>         Output directory (default: ../badges/)
 *   --optimise            Run optimisation (pngquant, mozjpeg)
 *   --verbose             Verbose output
 *   --help                Show this help message
 *
 * Examples:
 *   node convert.js badge.svg
 *   node convert.js --all
 *   node convert.js --format png --sizes 256,512,1024 logo.svg
 *   node convert.js --optimise badge.svg
 *
 * Requirements:
 *   - Node.js 14+
 *   - sharp library (npm install sharp)
 *   - Optional: pngquant, mozjpeg for optimisation
 *
 * Licence: Part of the Palimpsest License project
 * Author: Palimpsest Stewardship Council
 * Version: 1.0.0
 */

const fs = require('fs').promises;
const path = require('path');
const { exec } = require('child_process');
const util = require('util');

const execPromise = util.promisify(exec);

// Try to import sharp
let sharp;
try {
    sharp = require('sharp');
} catch (error) {
    console.error('\x1b[31m[ERROR]\x1b[0m sharp library not found.');
    console.error('Install with: npm install sharp');
    process.exit(1);
}

// Configuration
const config = {
    format: 'all',
    sizes: [512, 1024, 2048],
    outputDir: path.resolve(__dirname, '../../assets/badges'),
    brandingDir: path.resolve(__dirname, '../branding'),
    optimise: false,
    verbose: false,
    convertAll: false,
    inputFile: null,
};

// Colour codes for console output
const colours = {
    reset: '\x1b[0m',
    red: '\x1b[31m',
    green: '\x1b[32m',
    yellow: '\x1b[33m',
    blue: '\x1b[34m',
};

// Helper functions
function log(message) {
    console.log(`${colours.blue}[INFO]${colours.reset} ${message}`);
}

function success(message) {
    console.log(`${colours.green}[SUCCESS]${colours.reset} ${message}`);
}

function warn(message) {
    console.log(`${colours.yellow}[WARN]${colours.reset} ${message}`);
}

function error(message) {
    console.error(`${colours.red}[ERROR]${colours.reset} ${message}`);
}

function verbose(message) {
    if (config.verbose) {
        console.log(`${colours.blue}[VERBOSE]${colours.reset} ${message}`);
    }
}

// Show help message
function showHelp() {
    const help = `
Palimpsest License Asset Converter (Node.js/sharp version)

Usage:
  node convert.js [options] <input.svg>
  node convert.js --all

Options:
  --all                  Convert all SVG files in branding directory
  --format <fmt>         Convert to specific format (png|jpg|tiff|all)
  --sizes <sizes>        Comma-separated sizes (e.g., 512,1024,2048)
  --output <dir>         Output directory (default: ../badges/)
  --optimise            Run optimisation (pngquant, mozjpeg)
  --verbose             Verbose output
  --help                Show this help message

Examples:
  node convert.js badge.svg
  node convert.js --all
  node convert.js --format png --sizes 256,512,1024 logo.svg
  node convert.js --optimise badge.svg

Requirements:
  - Node.js 14+
  - sharp library (npm install sharp)
  - librsvg for SVG support
  - Optional: pngquant, mozjpeg for optimisation
`;

    console.log(help);
    process.exit(0);
}

// Check if command exists
async function commandExists(cmd) {
    try {
        await execPromise(`which ${cmd}`);
        return true;
    } catch {
        return false;
    }
}

// Check dependencies
async function checkDependencies() {
    verbose('Checking sharp SVG support...');

    try {
        const formats = sharp.format;
        if (!formats.svg || !formats.svg.input) {
            error('Sharp does not have SVG support enabled.');
            error('Install librsvg: sudo apt-get install librsvg2-dev');
            error('Then rebuild sharp: npm rebuild sharp');
            process.exit(1);
        }
        verbose('Sharp SVG support confirmed');
    } catch (err) {
        error(`Error checking sharp capabilities: ${err.message}`);
        process.exit(1);
    }

    if (config.optimise) {
        const hasPngquant = await commandExists('pngquant');
        const hasJpegoptim = await commandExists('jpegoptim');

        if (!hasPngquant) {
            warn('pngquant not found (PNG optimisation disabled)');
            warn('Install with: sudo apt-get install pngquant');
        }

        if (!hasJpegoptim) {
            warn('jpegoptim not found (JPG optimisation disabled)');
            warn('Install with: sudo apt-get install jpegoptim');
        }
    }
}

// Ensure directory exists
async function ensureDir(dir) {
    try {
        await fs.mkdir(dir, { recursive: true });
    } catch (err) {
        error(`Failed to create directory ${dir}: ${err.message}`);
        throw err;
    }
}

// Optimise PNG file
async function optimisePng(file) {
    if (!await commandExists('pngquant')) {
        return;
    }

    verbose(`Optimising PNG with pngquant: ${file}`);

    try {
        await execPromise(`pngquant --quality=80-95 --ext .png --force "${file}"`);
        verbose(`Optimised: ${file}`);
    } catch (err) {
        warn(`PNG optimisation failed: ${err.message}`);
    }
}

// Optimise JPG file
async function optimiseJpg(file) {
    if (!await commandExists('jpegoptim')) {
        return;
    }

    verbose(`Optimising JPG with jpegoptim: ${file}`);

    try {
        await execPromise(`jpegoptim --max=95 --strip-all "${file}"`);
        verbose(`Optimised: ${file}`);
    } catch (err) {
        warn(`JPG optimisation failed: ${err.message}`);
    }
}

// Convert SVG to PNG
async function convertToPng(inputPath, size, outputPath) {
    verbose(`Converting ${inputPath} to PNG (${size}px)`);

    try {
        await sharp(inputPath, { density: 300 })
            .resize(size, null, {
                fit: 'inside',
                withoutEnlargement: false,
            })
            .png({
                quality: 95,
                compressionLevel: 9,
            })
            .toFile(outputPath);

        success(`Created PNG: ${outputPath}`);

        if (config.optimise) {
            await optimisePng(outputPath);
        }

        return true;
    } catch (err) {
        error(`Failed to create PNG: ${err.message}`);
        return false;
    }
}

// Convert SVG to JPG
async function convertToJpg(inputPath, size, outputPath) {
    verbose(`Converting ${inputPath} to JPG (${size}px)`);

    try {
        await sharp(inputPath, { density: 300 })
            .resize(size, null, {
                fit: 'inside',
                withoutEnlargement: false,
            })
            .flatten({ background: { r: 255, g: 255, b: 255 } })
            .jpeg({
                quality: 95,
                chromaSubsampling: '4:4:4',
            })
            .toFile(outputPath);

        success(`Created JPG: ${outputPath}`);

        if (config.optimise) {
            await optimiseJpg(outputPath);
        }

        return true;
    } catch (err) {
        error(`Failed to create JPG: ${err.message}`);
        return false;
    }
}

// Convert SVG to TIFF
async function convertToTiff(inputPath, outputPath) {
    verbose(`Converting ${inputPath} to TIFF`);

    try {
        await sharp(inputPath, { density: 300 })
            .tiff({
                compression: 'lzw',
                quality: 100,
                xres: 300,
                yres: 300,
            })
            .toFile(outputPath);

        success(`Created TIFF: ${outputPath}`);
        return true;
    } catch (err) {
        error(`Failed to create TIFF: ${err.message}`);
        return false;
    }
}

// Process single SVG file
async function processSvg(inputPath) {
    const basename = path.basename(inputPath, '.svg');

    log(`Processing: ${inputPath}`);

    // Create output directories
    const dirs = ['png', 'jpg', 'tiff', 'svg'];
    for (const dir of dirs) {
        await ensureDir(path.join(config.outputDir, dir));
    }

    // Copy original SVG
    const svgOutput = path.join(config.outputDir, 'svg', `${basename}.svg`);
    await fs.copyFile(inputPath, svgOutput);
    success(`Copied SVG to ${svgOutput}`);

    // Convert to PNG
    if (config.format === 'all' || config.format === 'png') {
        for (const size of config.sizes) {
            const output = path.join(
                config.outputDir,
                'png',
                `${basename}-${size}w.png`
            );
            await convertToPng(inputPath, size, output);
        }
    }

    // Convert to JPG
    if (config.format === 'all' || config.format === 'jpg') {
        for (const size of config.sizes) {
            const output = path.join(
                config.outputDir,
                'jpg',
                `${basename}-${size}w.jpg`
            );
            await convertToJpg(inputPath, size, output);
        }
    }

    // Convert to TIFF
    if (config.format === 'all' || config.format === 'tiff') {
        const output = path.join(
            config.outputDir,
            'tiff',
            `${basename}-archival.tiff`
        );
        await convertToTiff(inputPath, output);
    }
}

// Find all SVG files in directory
async function findSvgFiles(dir) {
    const files = [];

    async function scan(currentDir) {
        const entries = await fs.readdir(currentDir, { withFileTypes: true });

        for (const entry of entries) {
            const fullPath = path.join(currentDir, entry.name);

            if (entry.isDirectory()) {
                await scan(fullPath);
            } else if (entry.isFile() && entry.name.endsWith('.svg')) {
                files.push(fullPath);
            }
        }
    }

    await scan(dir);
    return files;
}

// Parse command line arguments
function parseArgs() {
    const args = process.argv.slice(2);

    for (let i = 0; i < args.length; i++) {
        const arg = args[i];

        switch (arg) {
            case '--all':
                config.convertAll = true;
                break;

            case '--format':
                config.format = args[++i];
                if (!['png', 'jpg', 'tiff', 'all'].includes(config.format)) {
                    error(`Invalid format: ${config.format}`);
                    process.exit(1);
                }
                break;

            case '--sizes':
                config.sizes = args[++i].split(',').map(Number);
                break;

            case '--output':
                config.outputDir = path.resolve(args[++i]);
                break;

            case '--optimise':
            case '--optimize':
                config.optimise = true;
                break;

            case '--verbose':
                config.verbose = true;
                break;

            case '--help':
                showHelp();
                break;

            default:
                if (arg.startsWith('--')) {
                    error(`Unknown option: ${arg}`);
                    showHelp();
                } else {
                    config.inputFile = path.resolve(arg);
                }
                break;
        }
    }
}

// Main function
async function main() {
    parseArgs();

    await checkDependencies();

    log('Palimpsest License Asset Converter v1.0.0 (Node.js/sharp)');
    log(`Format: ${config.format}`);
    log(`Sizes: ${config.sizes.join(', ')}`);
    log(`Output: ${config.outputDir}`);
    log(`Optimise: ${config.optimise}`);
    console.log('');

    try {
        if (config.convertAll) {
            const svgFiles = await findSvgFiles(config.brandingDir);

            if (svgFiles.length === 0) {
                warn(`No SVG files found in: ${config.brandingDir}`);
                return;
            }

            log(`Found ${svgFiles.length} SVG files`);
            console.log('');

            for (const svgFile of svgFiles) {
                await processSvg(svgFile);
                console.log('');
            }
        } else {
            if (!config.inputFile) {
                error('No input file specified');
                showHelp();
            }

            try {
                await fs.access(config.inputFile);
            } catch {
                error(`File not found: ${config.inputFile}`);
                process.exit(1);
            }

            await processSvg(config.inputFile);
        }

        console.log('');
        success('Conversion complete!');
        log(`Output directory: ${config.outputDir}`);
    } catch (err) {
        error(`Conversion failed: ${err.message}`);
        if (config.verbose) {
            console.error(err.stack);
        }
        process.exit(1);
    }
}

// Run main function
if (require.main === module) {
    main();
}

module.exports = {
    convertToPng,
    convertToJpg,
    convertToTiff,
    processSvg,
};
