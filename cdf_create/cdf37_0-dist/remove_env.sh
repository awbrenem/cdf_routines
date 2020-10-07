#!/bin/sh
  input_file="/Users/aaronbreneman/.cshrc"
  output_file="cshrc$$"
  while read rec;
  do
     if [ "$rec" = "###########################################" ];
     then
        read rec1
        if [ "$rec1" = "#  CDF environment variables declaration" ];
        then
          for i in `jot 4`;
          do
              read rec
          done
        else
          echo "$rec" 1>&3
          echo "$rec1" 1>&3
        fi
     else
        echo "$rec" 1>&3
     fi
  done <$input_file 3>"$output_file"

  rm -f $input_file
  mv $output_file $input_file

  input_file="/Users/aaronbreneman/.profile"
  output_file="profile$$"
  while read rec;
  do
     if [ "$rec" = "###########################################" ];
     then
        read rec1
        if [ "$rec1" = "#  CDF environment variables declaration" ];
        then
          for i in `jot 4`;
          do
              read rec
          done
        else
          echo "$rec" 1>&3
          echo "$rec1" 1>&3
        fi
     else
        echo "$rec" 1>&3
     fi
  done <$input_file 3>"$output_file"

  rm -f $input_file
  mv $output_file $input_file

