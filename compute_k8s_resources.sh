res_cpu=$(kubectl -n $1 get pods -o=jsonpath='{.items[*]..resources.requests.cpu}')
let tot=0
for i in $res_cpu
do
   if [[ $i =~ "m" ]]; then
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot=$(( tot + i ))
   else
      tot=$(( tot + i*1000 ))
   fi
done
echo "Sum of all CPU requests: $tot m"

res_mem=$(kubectl -n $1 get pods -o=jsonpath='{.items[*]..resources.requests.memory}')
let tot_mem=0
for i in $res_mem
do
   if [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
    then
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_mem=$(( tot_mem + i ))
   else
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_mem=$(( tot_mem + i*1000 ))
   fi
done
echo "Sum of all Memory requests: $tot_mem MiB"

res_pvc=$(kubectl -n $1 get pvc -o=jsonpath='{.items[*].spec.resources.requests.storage}')
let tot_pvc=0
for i in $res_pvc
do
   if [[ $i =~ "G" ]] || [[ $i =~ "g" ]]
    then
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_pvc=$(( tot_pvc + i ))
   elif [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
   then
     i=$(echo $i | sed 's/[^0-9]*//g')
     tot_pvc=$(( tot_pvc + i/1000 ))
   else
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_pvc=$(( tot_pvc + i*1000 ))
   fi
done
echo "Sum of all PVC requests: $tot_pvc GiB"


res_cpu=$(kubectl -n $1 get pods -o=jsonpath='{.items[*]..resources.limits.cpu}')
let tot=0
for i in $res_cpu
do
   if [[ $i =~ "m" ]]; then
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot=$(( tot + i ))
   else
      tot=$(( tot + i*1000 ))
   fi
done
echo "Sum of all CPU limits: $tot m"

res_mem=$(kubectl -n $1 get pods -o=jsonpath='{.items[*]..resources.limits.memory}')
let tot_mem=0
for i in $res_mem
do
   if [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
    then
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_mem=$(( tot_mem + i ))
   else
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_mem=$(( tot_mem + i*1000 ))
   fi
done
echo "Sum of all Memory limits: $tot_mem MiB"

res_pvc=$(kubectl -n $1 get pvc -o=jsonpath='{.items[*].spec.resources.limits.storage}')
let tot_pvc=0
for i in $res_pvc
do
   if [[ $i =~ "G" ]] || [[ $i =~ "g" ]]
    then
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_pvc=$(( tot_pvc + i ))
   elif [[ $i =~ "M" ]] || [[ $i =~ "m" ]]
   then
     i=$(echo $i | sed 's/[^0-9]*//g')
     tot_pvc=$(( tot_pvc + i/1000 ))
   else
      i=$(echo $i | sed 's/[^0-9]*//g')
      tot_pvc=$(( tot_pvc + i*1000 ))
   fi
done
echo "Sum of all PVC limits: $tot_pvc GiB"