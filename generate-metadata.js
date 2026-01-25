const fs = require('fs');
const path = require('path');

// Configuration
const TOTAL_FILES = 5000;
const OUTPUT_DIR = 'course-metadata';
const IMAGE_URL = 'ipfs://bafkreiawpz2cyeckfyjck5ugdkpekcoot2t2ooprmptzqwc4kixc7h3pli';
const COURSE_NAME = 'Solidity Fundamentals';

// Create output directory if it doesn't exist
if (!fs.existsSync(OUTPUT_DIR)) {
    fs.mkdirSync(OUTPUT_DIR, { recursive: true });
    console.log(`Created directory: ${OUTPUT_DIR}`);
}

console.log('Starting metadata generation...');
console.log(`Generating ${TOTAL_FILES} JSON files...`);
console.log('');

// Generate JSON files
for (let i = 0; i < TOTAL_FILES; i++) {
    // Generate student ID with leading zeros (KL-SOL-0001, KL-SOL-0002, etc.)
    const studentId = `KL-SOL-${String(i + 1).padStart(4, '0')}`;
    
    // Create metadata object
    const metadata = {
        name: `Kayaba Labs - ${COURSE_NAME} Certificate`,
        description: `This certificate verifies that the holder has successfully completed the ${COURSE_NAME} course at Kayaba Labs. Student ID: ${studentId}. This is a soulbound NFT and cannot be transferred.`,
        image: IMAGE_URL,
        external_url: 'https://kayabalabs.com',
        attributes: [
            {
                trait_type: 'Student ID',
                value: studentId
            },
            {
                trait_type: 'Achievement Type',
                value: 'Course Completion'
            },
            {
                trait_type: 'Course Name',
                value: COURSE_NAME
            },
            {
                trait_type: 'Institution',
                value: 'Kayaba Labs'
            },
            {
                trait_type: 'Course Level',
                value: 'Beginner'
            },
            {
                trait_type: 'Certificate Type',
                value: 'Soulbound NFT'
            },
            {
                trait_type: 'Token ID',
                value: i.toString()
            }
        ]
    };
    
    // Write JSON file
    const filename = `${i}.json`;
    const filepath = path.join(OUTPUT_DIR, filename);
    fs.writeFileSync(filepath, JSON.stringify(metadata, null, 2));
    
    // Progress indicator
    if ((i + 1) % 500 === 0 || i === 0) {
        console.log(`Generated ${i + 1}/${TOTAL_FILES} files... (${((i + 1) / TOTAL_FILES * 100).toFixed(1)}%)`);
    }
}

console.log('');
console.log('✅ Metadata generation complete!');
console.log('');
console.log('📁 Files created in:', path.resolve(OUTPUT_DIR));
console.log('📊 Total files:', TOTAL_FILES);
console.log('🔢 Student ID range: KL-SOL-0001 to KL-SOL-5000');
console.log('');
console.log('Next steps:');
console.log('1. Navigate to the output directory');
console.log('2. Upload the entire folder to Pinata');
console.log('3. Copy the CID you receive');
console.log('4. Use that CID as your baseURI when deploying the contract');
console.log('');
console.log('Example files created:');
console.log(`  - ${OUTPUT_DIR}/0.json (Student ID: KL-SOL-0001)`);
console.log(`  - ${OUTPUT_DIR}/1.json (Student ID: KL-SOL-0002)`);
console.log(`  - ${OUTPUT_DIR}/4999.json (Student ID: KL-SOL-5000)`);