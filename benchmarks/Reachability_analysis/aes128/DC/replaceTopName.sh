find obj_dir -name "*Syms.cpp" | xargs sed -i 's/topp->name()/"TOP"/g' 
find obj_dir -name "*Syms.cpp" | xargs sed -i 's/name()/"KEYSCHEDULE"/g' 