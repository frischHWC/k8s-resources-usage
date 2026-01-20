echo "*****************"
echo "NAMESPACE: $1"
echo ""
echo "REQUESTS FOREACH Deployment: "
echo ""

out_file_reqs="./output_dep_reqs.csv"
out_file_lims="./output_dep_lims.csv"
echo "name,replicas,cpu_milli,memory_mb,pvc_gb" > $out_file_reqs
echo "name,replicas,cpu_milli,memory_mb" > $out_file_lims


### DEPLOYMENTS

res_deps=$(kubectl -n $1 get deployments -o=jsonpath='{.items[*]..metadata.name}')


for i in $res_deps
do
    replicas=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{.spec.replicas}')
    echo "  $i :"
    echo "    Replicas: $replicas"
    res_cpu=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{..resources.requests.cpu}')
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
    

    res_mem=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{..resources.requests.memory}')
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

    res_pvc=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{..resources.requests.storage}')
    let tot_pvc=0
    for p in $res_pvc
    do
        if [[ $p =~ "G" ]] || [[ $p =~ "g" ]]
        then
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p ))
        elif [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
        then
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p/1000 ))
        else
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p*1000 ))
        fi
    done

    echo "      STORAGE: $tot_pvc GB"

    echo "${i},${replicas},${tot_cpu},${tot_mem},${tot_pvc}" >> $out_file_reqs

    echo ""

done

echo ""
echo "LIMITS FOREACH Deployment: "
echo ""

for i in $res_deps
do
    replicas=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{.spec.replicas}')
    echo "  $i :"
    echo "    Replicas: $replicas"
    res_cpu=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{..resources.limits.cpu}')
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
    

    res_mem=$(kubectl -n $1 get deployment "$i" -o=jsonpath='{..resources.limits.memory}')
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

    echo "${i},${replicas}${tot_cpu},${tot_mem}" >> $out_file_lims

done



### STS

res_deps=$(kubectl -n $1 get sts -o=jsonpath='{.items[*]..metadata.name}')

echo ""
echo "REQUESTS FOREACH Stateful Set: "
echo ""

for i in $res_deps
do
    replicas=$(kubectl -n $1 get sts "$i" -o=jsonpath='{.spec.replicas}')
    echo "  $i :"
    echo "    Replicas: $replicas"
    res_cpu=$(kubectl -n $1 get sts "$i" -o=jsonpath='{..resources.requests.cpu}')
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
    

    res_mem=$(kubectl -n $1 get sts "$i" -o=jsonpath='{..resources.requests.memory}')
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

    res_pvc=$(kubectl -n $1 get sts "$i" -o=jsonpath='{..resources.requests.storage}')
    let tot_pvc=0
    for p in $res_pvc
    do
        if [[ $p =~ "G" ]] || [[ $p =~ "g" ]]
        then
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p ))
        elif [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
        then
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p/1000 ))
        else
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p*1000 ))
        fi
    done

    echo "      STORAGE: $tot_pvc GB"

    echo "${i},${replicas},${tot_cpu},${tot_mem},${tot_pvc}" >> $out_file_reqs

    echo ""

done

echo ""
echo "LIMITS FOREACH Stateful Set: "
echo ""

for i in $res_deps
do
    replicas=$(kubectl -n $1 get sts "$i" -o=jsonpath='{.spec.replicas}')
    echo "  $i :"
    echo "    Replicas: $replicas"
    res_cpu=$(kubectl -n $1 get sts "$i" -o=jsonpath='{..resources.limits.cpu}')
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
    

    res_mem=$(kubectl -n $1 get sts "$i" -o=jsonpath='{..resources.limits.memory}')
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

    echo "${i},${replicas}${tot_cpu},${tot_mem}" >> $out_file_lims

done


### DS

res_deps=$(kubectl -n $1 get ds -o=jsonpath='{.items[*]..metadata.name}')

echo ""
echo "REQUESTS FOREACH Daemon Set: "
echo ""

for i in $res_deps
do
    echo "  $i :"
    res_cpu=$(kubectl -n $1 get ds "$i" -o=jsonpath='{..resources.requests.cpu}')
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
    

    res_mem=$(kubectl -n $1 get ds "$i" -o=jsonpath='{..resources.requests.memory}')
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

    res_pvc=$(kubectl -n $1 get ds "$i" -o=jsonpath='{..resources.requests.storage}')
    let tot_pvc=0
    for p in $res_pvc
    do
        if [[ $p =~ "G" ]] || [[ $p =~ "g" ]]
        then
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p ))
        elif [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
        then
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p/1000 ))
        else
        p=$(echo $p | sed 's/[^0-9]*//g')
        tot_pvc=$(( tot_pvc + p*1000 ))
        fi
    done

    echo "      STORAGE: $tot_pvc GB"

    echo "${i},X,${tot_cpu},${tot_mem},${tot_pvc}" >> $out_file_reqs

    echo ""

done

echo ""
echo "LIMITS FOREACH Daemon Set: "
echo ""

for i in $res_deps
do
    replicas=$(kubectl -n $1 get ds "$i" -o=jsonpath='{.spec.replicas}')
    echo "  $i :"
    echo "    Replicas: $replicas"
    res_cpu=$(kubectl -n $1 get ds "$i" -o=jsonpath='{..resources.limits.cpu}')
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
    

    res_mem=$(kubectl -n $1 get ds "$i" -o=jsonpath='{..resources.limits.memory}')
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

    echo "${i},${replicas}${tot_cpu},${tot_mem}" >> $out_file_lims

done