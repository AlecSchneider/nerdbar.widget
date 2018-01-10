# Display spaces using in a bar that accepts stdout
chunkc=~/../../usr/local/bin/chunkc
. nerdbar.widget/scripts/config.sh


# get active and previous space
active=$($chunkc tiling::query --desktop id)

# get array of spaces
spaces=()
i=0
while read -r line
do
    for word in $line; do
        spaces[i]="$word"
        (( i++ ))
    done
done <<< "$($chunkc tiling::query --desktops-for-monitor 1)"

# populate bar with icons
bar=()
for (( i = 0; i < ${#spaces[@]}; i++ ))
do
	if [[ ${spaces[$i]} == *"[no tag]" ]] #|| "$i" -lt 5 ]]
	then
		bar[$i]=$(($i+1))
	else
		if [[ "$i" == "9" ]]
		then
			id="${spaces[$i]:4}"
		else
			id="${spaces[$i]:3}"
		fi
		# bar[$i]="$(echo $id | tr '[:lower:]' '[:upper:]')"
		 bar[$i]="$(echo $id )"
	fi
done

# style active and previous space icons
bbar=()
for (( i = 0; i < ${#bar[@]}; i++ ))
do
	if [[ $(($i+1)) == "$active" ]]
	then
		bbar[(($i*3+1))]="($(($i+1)))"
	else
		bbar[(($i*3+1))]="($(($i+1))"
	fi
done
echo "[$($chunkc tiling::query --desktop mode)]@${bbar[*]}@$($chunkc tiling::query --window tag)"
