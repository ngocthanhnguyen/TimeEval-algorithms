#!/bin/bash
 
data_file=Wave_Height_test.csv
execution_log=2-results/Wave_Height_log.txt
 
# Function to run a program and track the total number of running processes
run_program() {
  echo "Running alg.: $1"
  docker run --rm -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "train", "dataInput": "/data/'$data_file'", "dataOutput": "/results/'$1'_'$data_file'.ts", "modelInput": "/results/'$1'_'$data_file'.pkl", "modelOutput": "/results/'$1'_'$data_file'.pkl"}' &
  wait
  start=`date +%s.%N`
  docker run --rm -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "execute", "dataInput": "/data/'$data_file'", "dataOutput": "/results/'$1'_'$data_file'.ts", "modelInput": "/results/'$1'_'$data_file'.pkl", "modelOutput": "/results/'$1'_'$data_file'.pkl"}' &
  wait
  end=`date +%s.%N`
  runtime=$( echo "$end - $start" | bc -l )
  
  echo "=====================" >> $execution_log
  date >> $execution_log
  echo $start  >> $execution_log
  echo $end  >> $execution_log
  echo $runtime  >> $execution_log
  ((running_processes--))
}
 
# Array of programs to run
programs=("adapad_eif" "adapad_iforest" "adapad_knn" "adapad_hybrid_knn" "adapad_generic_rf" "adapad_subsequence_lof" "adapad_tanogan" "adapad_cof" "adapad_generic_xgb" "adapad_subsequence_knn" "adapad_ocean_wnn" "adapad_lstm_ad" "adapad_encdec_ad" "adapad_sr_cnn" "adapad_lof" "adapad_median_method" "adapad_dspot" "adapad_torsk" "adapad_multi_subsequence_lof" "adapad_robust_pca" "adapad_hif" "adapad_novelty_svr" "adapad_phasespace_svm" "adapad_pci" "adapad_damp" "adapad_mtad_gat" "adapad_cblof" "adapad_copod" "adapad_subsequence_fast_mcd" "adapad_fast_mcd" "adapad_img_embedding_cae" "adapad_dae" "adapad_multi_hmm" "adapad_random_black_forest" "adapad_sr" "adapad_normalizing_flows" "adapad_hbos" "adapad_bagel" "adapad_telemanom" "adapad_pcc" "adapad_triple_es" "adapad_lstm_vae" "adapad_laser_dbn" "adapad_dbstream" "adapad_baseline_random" "adapad_s_h_esd" "adapad_autoencoder" "adapad_baseline_normal" "adapad_deepnap" "adapad_tarzan" "adapad_sarima" "adapad_left_stampi" "adapad_mscred" "adapad_baseline_increasing" "adapad_donut" "adapad_omnianomaly" "adapad_if_lof" "adapad_kmeans" "adapad_mstamp" "adapad_hotsax" "adapad_ensemble_gi" "adapad_dwt_mlead" "adapad_subsequence_if" "adapad_deepant" "adapad_health_esn" "adapad_fft")
 
# Maximum number of parallel programs to run
max_parallel=4
 
# Counter for running processes
running_processes=0
 
# Iterate through the programs array
for program in "${programs[@]}"; do
  # Check if the maximum number of parallel programs is reached
  if [ $running_processes -ge $max_parallel ]; then
    # Wait for any running program to finish before launching a new one
    wait -n
  fi
 
  # Run the program in the background and track the running processes
  run_program "$program" &
  ((running_processes++))
done
 
# Wait for all remaining programs to finish
wait
 
echo "All programs have finished running."
