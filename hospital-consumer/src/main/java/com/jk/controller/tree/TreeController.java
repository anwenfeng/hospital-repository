package com.jk.controller.tree;

import com.jk.service.tree.TreeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

@Controller
public class TreeController {

    @Autowired
    private TreeService treeService;

}
