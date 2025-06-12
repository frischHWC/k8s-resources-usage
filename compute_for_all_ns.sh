for i in $( kubectl get ns | awk '{print $1}' ) ; do 
    ./compute_k8s_resources.sh $i   
done