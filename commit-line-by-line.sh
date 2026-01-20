#!/bin/bash

# commit-line-by-line.sh
# Commits a file line-by-line for granular version control
    
    # Show progress every 10 lines
    if [ $((LINE_NUM % 10)) -eq 0 ] || [ $LINE_NUM -eq $TOTAL_LINES ]; then
        PERCENT=$((LINE_NUM * 100 / TOTAL_LINES))
        echo -e "${GREEN}Progress: $LINE_NUM/$TOTAL_LINES lines ($PERCENT%) - $COMMIT_COUNT commits${NC}"
    fi
    
echo ""
echo -e "${YELLOW}Recent commits:${NC}"
git log --oneline -10
echo ""
echo -e "${YELLOW}To view all commits for this file:${NC}"
echo "git log --oneline -- $FILE_PATH"
echo ""
echo ""
echo -e "${YELLOW}To see changes in a specific commit:${NC}"
echo "git show <commit-hash>"