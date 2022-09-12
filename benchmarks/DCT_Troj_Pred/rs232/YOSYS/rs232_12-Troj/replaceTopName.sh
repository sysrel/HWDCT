find obj_dir -name "*.cpp" | xargs sed -i 's/topp->name()/"TOP"/g' 
find obj_dir -name "*.cpp" | xargs sed -i 's/name()/"U_XMIT"/g' 