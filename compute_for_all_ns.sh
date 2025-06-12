for i in $(k get ns | awk '{print $1}') ; do 
    ./compute_k8s_resources.sh $i   
done