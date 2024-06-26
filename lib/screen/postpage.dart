import 'package:flutter/material.dart';
class PostPage extends StatefulWidget {
  const PostPage({super.key});

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: (){},
             child: Text("Post",style: TextStyle(fontSize: 15,color: Colors.blue),))
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextFormField(
              maxLines: 20,
              decoration: InputDecoration(
                hintText: "Whats on your mind...?",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16)
                )
              ),
            ),
          ),
                                  Divider(),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        SizedBox(
                          height: height * 0.01,
                        ),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            ActionButton(
                              icon: Icons.file_present,
                              color: Colors.black,
                              label: "File",
                              onTap: () {},
                            ),
                            SizedBox(height: height*0.02),
                             Divider(),
                            ActionButton(
                              icon: Icons.photo,
                              color: Colors.black,
                              label: "Photos",
                              onTap: () {},
                            ),
                            
                            SizedBox(height: height*0.02),
                            Divider(),
                          ],
                        ),
        ],
      ),
    );
  }
}
class ActionButton extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String label;
  final VoidCallback onTap;

  const ActionButton({
    required this.icon,
    required this.color,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 35,
          ),
          SizedBox(width: 5),
          Text(label),
        ],
      ),
    );
  }
}
