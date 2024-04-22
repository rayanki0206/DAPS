if [ ! -f 'inputs.tfvars' ]
then
  echo "File does not exist. Skipping..."
else
  rm 'inputs.tfvars'
  echo "file removed"
fi
