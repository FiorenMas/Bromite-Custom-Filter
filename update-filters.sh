readonly -A FILTERS=(
    ['adguard-easy.txt']='https://filters.adtidy.org/android/filters/2_optimized.txt'
    ['adguard-mobile-ads.txt']='https://filters.adtidy.org/android/filters/11_optimized.txt'
    ['adguard-tracking-protection.txt']='https://filters.adtidy.org/android/filters/3_optimized.txt'
    ['abpvn.txt']='https://raw.githubusercontent.com/abpvn/abpvn/master/filter/abpvn.txt'
    ['abpvn-luxysiv.txt']='https://raw.githubusercontent.com/luxysiv/filters/main/abpvn-ext.txt'
    ['adguard-url-tracking.txt']='https://filters.adtidy.org/extension/ublock/filters/17_optimized.txt'
)

function join_by { local IFS="$1"; shift; echo "$*"; }

for filter in "${!FILTERS[@]}"; do
    url="${FILTERS[$filter]}"
    echo "Downloading $filter from $url"
    if ! curl -o "$filter" "$url"; then
        echo "Failed to download $url"
        exit 1
    fi
    echo
done

#join_by , "${!FILTERS[@]}"

echo "Converting filters"
./ruleset_converter --input_format=filter-list \
                    --output_format=unindexed-ruleset \
                    --input_files="$(join_by , "${!FILTERS[@]}")" \
                    --output_file=filters.dat
