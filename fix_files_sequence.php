<?php
/**
 * Fix files table sequence
 * Run this script once to sync the files_id_seq sequence with the current data
 */

require_once 'config/database.php';

$db = new Database();

echo "Fixing files table sequence...\n\n";

// Get current max ID from files table
$result = $db->query("SELECT MAX(id) as max_id FROM files");
$row = $db->fetch($result);
$maxId = $row['max_id'] ?? 0;

echo "Current max ID in files table: $maxId\n";

// Get current sequence value
$result = $db->query("SELECT last_value FROM files_id_seq");
$row = $db->fetch($result);
$currentSeq = $row['last_value'] ?? 0;

echo "Current sequence value: $currentSeq\n\n";

// If max ID is greater than sequence, update the sequence
if ($maxId >= $currentSeq) {
    $newSeqValue = $maxId + 1;
    $result = $db->query("SELECT setval('files_id_seq', $newSeqValue, false)");
    
    if ($result) {
        echo "✓ Sequence updated successfully!\n";
        echo "New sequence value: $newSeqValue\n";
    } else {
        echo "✗ Failed to update sequence\n";
        echo "Error: " . pg_last_error($db->getConnection()) . "\n";
    }
} else {
    echo "✓ Sequence is already in sync. No action needed.\n";
}

echo "\n=== Done ===\n";
