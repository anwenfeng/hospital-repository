package com.jk.service.tree;

import com.jk.dao.tree.TreeMapper;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service("treeService")
public class TreeServiceImpl implements TreeService {

    @Autowired
    private TreeMapper treeMapper;

}
