# FavScene

This is my second attempt to create a plugin for Godot. Ther first one was the name generator, following [Emilio's Tutorial](https://www.youtube.com/watch?v=qy4nBHMXIPk). I based this plugin on [Pigdev godot sandbox](https://www.youtube.com/watch?v=7kUGy37Uh4A) and [Sansface video about plugins](https://www.youtube.com/watch?v=aMHYB_qX8fA). Lot of my code was based on Sansface's work and if you compare our code, you will see that I've used lot of his code to. Man, if you ever read this, the snaping code is working ok but I have no idea how to make your pallet code works =\




This plugin add an area with easy acess on scenes to speed up 2d prototyping. I put some files with the addon so you can test it

# Table of contents
1. [How to install](#install)
2. [How to use](#use)
3. [Know issues](#issues)

## How to install <a name="install"></a>

Just put the addons/fav_scene on your directory and enable it in the editor

![alt text](https://github.com/jaspior/FavScene/blob/main/Images/Enable.png "enabling it on editor")

After installed, you'll notice a new dock/tab on the uper right side. You can change it's position later. Here is how it'll look:

![alt text](https://github.com/jaspior/FavScene/blob/main/Images/dock1.png "click here") ![alt text](https://github.com/jaspior/FavScene/blob/main/Images/dock_Clean.png "Dock clean")

You can add buttons, save them so when you open the project the fav scenes will be there, and clear the save. 


## How to use <a name="use"></a>

To add a scene, just click add and find it in the dialog box

![alt text](https://github.com/jaspior/FavScene/blob/main/Images/find_scene.png "click here")

Keep in mind that, for some reason you can only add scenes that you had opened recently, probably due to the use of queue_resource_preview 


```

void queue_resource_preview ( String path, Object receiver, String receiver_func, Variant userdata )

Queue a resource file located at path for preview. Once the preview is ready, the receiver's receiver_func will be called.
The receiver_func must take the following four arguments: String path, Texture preview, Texture thumbnail_preview, Variant userdata. 
userdata can be anything, and will be returned when receiver_func is called.

Note: If it was not possible to create the preview the receiver_func will still be called, but the preview will be null.

```

This may slow down your work, sorry =\

After, just select the scene you want to instance and right click. It will add a copy there

![](https://github.com/jaspior/FavScene/blob/main/Images/save%20persist.png)

Be sure to select the first tree node or it won't be instanced and saved. I tried to make it possible to instance on any node in the tree but I was unsuccessful.

## Known Issues <a name="issues"></a>

- I wasn't able to hide/show it, that's why I've choose to make it a dock. I probably didn't understand the documentation so any help is usefull
- If you don't open and save the scene one time before adding it to the dock, It wont be added. After it, you can save and you won't need to worry about it
- Due to forward_canvas_gui_input, all your righ clicks will instance the last selected scene to the scene tree.
- Don't forget to select a tree node. It have to inherit from CanvasItem (any control or 2d node) due to the 	global_position call. If you try to add the scenes to other type of node or no node att all, you'll have to reload godot.
