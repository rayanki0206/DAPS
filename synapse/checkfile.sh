if [ ! -f 'inputs.auto.tfvars' ]
then
  echo "File does not exist. Skipping..."
else
  rm 'inputs.tfvars'
  echo "file removed"
fi
