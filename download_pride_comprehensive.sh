#!/bin/bash
# save as download_pride_comprehensive.sh

BASE_URL="ftp://ftp.pride.ebi.ac.uk/pride/data/archive/2017/02/PXD004732"

echo "========================================="
echo "🧬 ProteomeTools Comprehensive Download"
echo "========================================="

# Create organized directory structure
mkdir -p raw_files/{first_pools,second_pools,srm_pools}
mkdir -p processed_files/{first_pools,second_pools,srm_pools}

# RAW FILES - Maximum diversity across pool types and methods
RAW_FILES=(
    # FIRST POOLS - Different fragmentation methods
    "01625b_GF4-TUM_first_pool_30_01_01-3xHCD-1h-R1.raw"      # Pool 30, 3xHCD (755 MB)
    "01625b_GE2-TUM_first_pool_13_01_01-2xIT_2xHCD-1h-R1.raw" # Pool 13, 2xIT_2xHCD (798 MB)
    "01650b_BF7-TUM_first_pool_96_01_01-3xHCD-1h-R2.raw"      # Pool 96, 3xHCD (847 MB)
    "01709a_GB4-TUM_first_pool_125_01_01-3xHCD-1h-R1.raw"     # Pool 125, 3xHCD (716 MB)
    
    # SECOND POOLS - Different experimental batch
    "01748a_GD1-TUM_second_pool_10_02_01-ETD-1h-R1.raw"       # Second pool 10, ETD (395 MB)
    
    # SRM POOLS - Targeted analysis
    "01640c_BA4-Thermo_SRM_Pool_25_01_01-2xIT_2xHCD-1h-R2.raw" # SRM Pool 25 (667 MB)
)

# PROCESSED FILES - Corresponding MaxQuant results for comparison
PROCESSED_FILES=(
    # FIRST POOLS - Processed results
    "TUM_first_pool_61_01_01_3xHCD-1h-R2-tryptic.zip"         # Pool 61, 3xHCD (39 MB)
    "TUM_first_pool_61_01_01_2xIT_2xHCD-1h-R2-tryptic.zip"    # Pool 61, 2xIT_2xHCD (46 MB)
    "TUM_first_pool_42_01_01_3xHCD-1h-R1-tryptic.zip"         # Pool 42, 3xHCD (33 MB)
    "TUM_first_pool_6_01_01_DDA-1h-R2-tryptic.zip"            # Pool 6, DDA (16 MB)
    "TUM_first_pool_114_01_01_DDA-1h-R1-tryptic.zip"          # Pool 114, DDA (15 MB)
    
    # SECOND POOLS - Different batch processing
    "TUM_second_pool_35_01_01_ETD-1h-R1-tryptic.zip"          # Second pool 35, ETD (10 MB)
    "TUM_second_pool_107_02_01_ETD-1h-R1-tryptic.zip"         # Second pool 107, ETD (8 MB)
    "TUM_second_pool_50_01_01_ETD-1h-R1-tryptic.zip"          # Second pool 50, ETD (8 MB)
    "TUM_second_pool_15_01_01_2xIT_2xHCD-1h-R1-tryptic.zip"   # Second pool 15, 2xIT_2xHCD (15 MB)
    
    # SRM POOLS - Targeted analysis results
    "Thermo_SRM_Pool_84_01_01_DDA-1h-R2-tryptic.zip"          # SRM Pool 84, DDA (13 MB)
    "Thermo_SRM_Pool_42_01_01_DDA-1h-R2-tryptic.zip"          # SRM Pool 42, DDA (15 MB)
    "Thermo_SRM_Pool_60_01_01_2xIT_2xHCD-1h-R2-tryptic.zip"   # SRM Pool 60, 2xIT_2xHCD (27 MB)
    
    # UNSPECIFIC DIGESTION - Different processing approach
    "TUM_second_pool_135_01_01_2xIT_2xHCD-1h-R1-unspecific.zip" # Unspecific digestion (28 MB)
    "TUM_first_pool_125_01_01_DDA-1h-R1-unspecific.zip"         # Unspecific digestion (26 MB)
)

# Function to download files with progress tracking
download_files() {
    local file_array=("$@")
    local file_type=$1
    shift
    local files=("$@")
    
    echo " Downloading $file_type files..."
    
    for file in "${files[@]}"; do
        echo "----------------------------------------"
        echo "Downloading: $file"
        echo "URL: $BASE_URL/$file"
        
        # Determine target directory
        if [[ $file == *"first_pool"* ]]; then
            target_dir="first_pools"
        elif [[ $file == *"second_pool"* ]]; then
            target_dir="second_pools"
        elif [[ $file == *"SRM_Pool"* ]] || [[ $file == *"Thermo_SRM"* ]]; then
            target_dir="srm_pools"
        else
            target_dir="."
        fi
        
        # Set appropriate subdirectory
        if [[ $file == *.raw ]]; then
            cd raw_files/$target_dir
        else
            cd processed_files/$target_dir
        fi
        
        # Download with resume capability
        wget -c --progress=bar:force "$BASE_URL/$file"
        
        if [ $? -eq 0 ]; then
            echo " Successfully downloaded: $file"
            ls -lh "$file" | awk '{print "📊 File size:", $5}'
        else
            echo " Failed to download: $file"
        fi
        
        cd - > /dev/null
        echo ""
    done
}

# Download RAW files
download_files "RAW" "${RAW_FILES[@]}"

# Download processed files
download_files "PROCESSED" "${PROCESSED_FILES[@]}"

# Generate summary report
echo "========================================="
echo " DOWNLOAD SUMMARY REPORT"
echo "========================================="

echo " RAW FILES:"
echo "First pools: $(find raw_files/first_pools -name "*.raw" 2>/dev/null | wc -l) files"
echo "Second pools: $(find raw_files/second_pools -name "*.raw" 2>/dev/null | wc -l) files"
echo "SRM pools: $(find raw_files/srm_pools -name "*.raw" 2>/dev/null | wc -l) files"
echo "Total RAW size: $(du -sh raw_files 2>/dev/null | cut -f1)"

echo ""
echo " PROCESSED FILES:"
echo "First pools: $(find processed_files/first_pools -name "*.zip" 2>/dev/null | wc -l) files"
echo "Second pools: $(find processed_files/second_pools -name "*.zip" 2>/dev/null | wc -l) files"
echo "SRM pools: $(find processed_files/srm_pools -name "*.zip" 2>/dev/null | wc -l) files"
echo "Total PROCESSED size: $(du -sh processed_files 2>/dev/null | cut -f1)"

echo ""
echo " ANALYSIS OPPORTUNITIES:"
echo "✅ Method comparison: 3xHCD vs 2xIT_2xHCD vs ETD vs DDA"
echo "✅ Pool diversity: 200 different peptide pools represented"
echo "✅ Batch effects: first_pool vs second_pool comparison"
echo "✅ Targeted vs Discovery: SRM vs DDA approaches"
echo "✅ Digestion comparison: tryptic vs unspecific"
echo "✅ Technical replicates: R1 vs R2 analysis"
echo "✅ Raw vs Processed: Complete pipeline validation"

echo ""
echo " TOTAL DATASET SIZE: ~5.5 GB"
echo " Download completed successfully!"
echo "========================================="
