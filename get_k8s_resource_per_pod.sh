echo "*****************"
echo "NAMESPACE: $1"
echo ""
echo "REQUESTS FOREACH POD: "
echo ""

res_pods=$(kubectl -n $1 get pods -o=jsonpath='{.items[*]..metadata.name}')


for i in $res_pods
do
    echo "  $i :"
    res_cpu=$(kubectl -n $1 get pod "$i" -o=jsonpath='{..resources.requests.cpu}')
    let tot_cpu=0
    for c in $res_cpu
    do
        if [[ $c =~ "m" ]]; then
            c=$(echo $c | sed 's/[^0-9]*//g')
            tot_cpu=$(( tot_cpu + c ))
        else
            tot_cpu=$(( tot_cpu + c*1000 ))
        fi
    done

    echo "      CPU: $tot_cpu m"
    

    res_mem=$(kubectl -n $1 get pod "$i" -o=jsonpath='{..resources.requests.memory}')
    let tot_mem=0
    for m in $res_mem
    do
       if [[ $m =~ "M" ]] || [[ $m =~ "m" ]] || [[ $m =~ "Mi" ]]
        then
          m=$(echo $m | sed 's/[^0-9]*//g')
          tot_mem=$(( tot_mem + m ))
       else
          m=$(echo $m | sed 's/[^0-9]*//g')
          tot_mem=$(( tot_mem + m*1000 ))
       fi
    done

    echo "      MEMORY: $tot_mem MB"
    
    echo ""

done

echo ""
echo "LIMITS FOREACH POD: "
echo ""

for i in $res_pods
do
    echo "  $i :"
    res_cpu=$(kubectl -n $1 get pod "$i" -o=jsonpath='{..resources.limits.cpu}')
    let tot_cpu=0
    for c in $res_cpu
    do
        if [[ $c =~ "m" ]]; then
            c=$(echo $c | sed 's/[^0-9]*//g')
            tot_cpu=$(( tot_cpu + c ))
        else
            tot_cpu=$(( tot_cpu + c*1000 ))
        fi
    done

    echo "      CPU: $tot_cpu m"
    

    res_mem=$(kubectl -n $1 get pod "$i" -o=jsonpath='{..resources.limits.memory}')
    let tot_mem=0
    for m in $res_mem
    do
       if [[ $m =~ "M" ]] || [[ $m =~ "m" ]] || [[ $m =~ "Mi" ]]
        then
          m=$(echo $m | sed 's/[^0-9]*//g')
          tot_mem=$(( tot_mem + m ))
       else
          m=$(echo $m | sed 's/[^0-9]*//g')
          tot_mem=$(( tot_mem + m*1000 ))
       fi
    done

    echo "      MEMORY: $tot_mem MB"
    
    echo ""

done