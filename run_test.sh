#!/bin/bash
 
data_file=Wave_Height
execution_log=2-results/00_Wave_Height_log.txt
 
# Function to run a program and track the total number of running processes
run_program() {
  echo "Running alg.: $1"
  cd 2-results
  if [ -f $1_$data_file.ts ]; then
    echo $1 "done, exit"
    cd ..
    ((running_processes--))
  else   
      cd ..
      echo $1 "not executed yet"
      timeout -k 9 2h docker run --rm --memory=3g --cpus=1 -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "train", "dataInput": "/data/'$data_file'_train.csv", "dataOutput": "/results/'$1'_'$data_file'.ts", "modelInput": "/results/'$1'_'$data_file'.pkl", "modelOutput": "/results/'$1'_'$data_file'.pkl"}' &
      wait
      start=`date +%s.%N`
      timeout -k 9 2h docker run --rm --memory=3g --cpus=1 -v $(pwd)/1-data:/data:ro -v $(pwd)/2-results:/results:rw $1:latest execute-algorithm '{"executionType": "execute", "dataInput": "/data/'$data_file'_test.csv", "dataOutput": "/results/'$1'_'$data_file'.ts", "modelInput": "/results/'$1'_'$data_file'.pkl", "modelOutput": "/results/'$1'_'$data_file'.pkl"}' &
      wait
      end=`date +%s.%N`
      runtime=$( echo "$end - $start" | bc -l )
      
      echo "=====================" >> $execution_log
      echo $1 >> $execution_log
      date >> $execution_log
      echo $start  >> $execution_log
      echo $end  >> $execution_log
      echo $runtime  >> $execution_log
      ((running_processes--))
  fi
}
 
# Array of programs to run
programs=("adapad_valmod" "adapad_stomp" "adapad_mvalmod" "adapad_stamp" "adapad_iforest" "adapad_eif" "adapad_knn" "adapad_hybrid_knn" "adapad_generic_rf" "adapad_cof" "adapad_subsequence_lof" "adapad_tanogan" "adapad_generic_xgb" "adapad_subsequence_knn" "adapad_ocean_wnn" "adapad_lstm_ad" "adapad_sr_cnn" "adapad_encdec_ad" "adapad_median_method" "adapad_lof" "adapad_dspot" "adapad_torsk" "adapad_multi_subsequence_lof" "adapad_robust_pca" "adapad_novelty_svr" "adapad_phasespace_svm" "adapad_pci" "adapad_damp" "adapad_mtad_gat" "adapad_cblof" "adapad_copod" "adapad_subsequence_fast_mcd" "adapad_fast_mcd" "adapad_img_embedding_cae" "adapad_dae" "adapad_multi_hmm" "adapad_random_black_forest" "adapad_sr" "adapad_normalizing_flows" "adapad_hbos" "adapad_bagel" "adapad_telemanom" "adapad_pcc" "adapad_triple_es" "adapad_lstm_vae" "adapad_laser_dbn" "adapad_baseline_random" "adapad_dbstream" "adapad_s_h_esd" "adapad_autoencoder" "adapad_baseline_normal" "adapad_deepnap" "adapad_tarzan" "adapad_sarima" "adapad_left_stampi" "adapad_mscred" "adapad_baseline_increasing" "adapad_donut" "adapad_omnianomaly" "adapad_if_lof" "adapad_kmeans" "adapad_mstamp" "adapad_hotsax" "adapad_ensemble_gi" "adapad_dwt_mlead" "adapad_subsequence_if" "adapad_deepant" "adapad_health_esn" "adapad_fft")
 
# Maximum number of parallel programs to run
max_parallel=5
 
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
