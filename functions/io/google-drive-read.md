---
scope: function
category: io
priority: high
tags: [google-drive, sync, read]
---
# PURPOSE
Read files from Google Drive sync folder using paths from .env

# WHEN TO USE
- Reading workout CSV exports from Google Sheets
- Accessing synced markdown files
- Loading configuration files from cloud storage

# PREREQUISITES
- Google Drive Desktop installed and syncing
- Paths configured in `.env`:
  - `GOOGLE_DRIVE_ROOT`
  - `GOOGLE_DRIVE_AI_SYNC`
  - Specific file paths (e.g., `CALISTHENICS_THIS_WEEK_CSV`)

# USAGE

## 1. Check Environment Variables
```bash
# Verify paths are set
echo $GOOGLE_DRIVE_AI_SYNC
ls "$GOOGLE_DRIVE_AI_SYNC"
```

## 2. Read CSV Files
```bash
# Read workout tracking CSV
cat "$CALISTHENICS_THIS_WEEK_CSV"

# Parse CSV with specific columns
awk -F',' '{print $1, $2, $3}' "$CALISTHENICS_THIS_WEEK_CSV"
```

## 3. Read from Sync Folder
```bash
# List available files
ls -la "$GOOGLE_DRIVE_AI_SYNC"

# Read specific markdown file
cat "$GOOGLE_DRIVE_AI_SYNC/weekly-notes.md"
```

## 4. In Code (TypeScript/JavaScript)
```typescript
import fs from 'fs';
import path from 'path';

const syncFolder = process.env.GOOGLE_DRIVE_AI_SYNC!;
const csvPath = process.env.CALISTHENICS_THIS_WEEK_CSV!;

// Read CSV
const csvContent = fs.readFileSync(csvPath, 'utf-8');

// List files in sync folder
const files = fs.readdirSync(syncFolder);

// Read JSON config
const configPath = path.join(syncFolder, 'config.json');
const config = JSON.parse(fs.readFileSync(configPath, 'utf-8'));
```

# ERROR HANDLING

## Path Not Found
```bash
if [ ! -f "$GOOGLE_DRIVE_AI_SYNC/file.csv" ]; then
    echo "Error: File not found. Check:"
    echo "1. Google Drive Desktop is running"
    echo "2. Sync is complete"
    echo "3. Path in .env is correct"
    exit 1
fi
```

## Permission Issues
```bash
# Check read permissions
ls -la "$GOOGLE_DRIVE_AI_SYNC"

# Should show readable files (r-- or rw-)
```

# COMMON PATTERNS

## Read Weekly Workout Data
```bash
# Current week
cat "$CALISTHENICS_THIS_WEEK_CSV"

# Previous week
cat "$CALISTHENICS_PREVIOUS_WEEK_CSV"

# Compare weeks
diff "$CALISTHENICS_PREVIOUS_WEEK_CSV" "$CALISTHENICS_THIS_WEEK_CSV"
```

## Watch for Changes
```bash
# Monitor file for updates (useful for auto-sync)
fswatch -0 "$GOOGLE_DRIVE_AI_SYNC" | while read -d "" event; do
    echo "File changed: $event"
    # Process update
done
```

# NOTES
- Google Drive Desktop syncs to local filesystem
- Files appear as regular local files
- No API calls needed - direct filesystem access
- Sync can have lag - check file timestamp if data seems stale

# RELATED FUNCTIONS
- `csv-parse.md` - Parse CSV data
- `file-write.md` - Write back to sync folder
- `workout-log.md` - Process workout data
