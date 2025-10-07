import 'package:flutter/material.dart';
import '../widget/jop_card.dart';
import '../widget/jop_tile.dart';
import 'see_all_screen.dart';

class jops_screen extends StatelessWidget {
  const jops_screen({super.key});

  @override
  Widget categoryButton(String text, {VoidCallback? onTap}) {
  return Padding(
    
    padding: const EdgeInsets.symmetric(horizontal: 6.0),
    child: Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap ?? () {},
        borderRadius: BorderRadius.circular(16),
        child: Container(
          
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white70,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.grey,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.25),
                spreadRadius: 1,
                blurRadius: 5,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    ),
  );
 }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFA8E6CF), Colors.white], 
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
          child: AppBar(
            title: const Text("Jobs", style: TextStyle(color: Color.fromARGB(255, 0, 145, 73),fontWeight: FontWeight.bold)),
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
          ),
        ),
      ),

      
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Search
              Container(
            margin: const EdgeInsets.all(16),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: TextEditingController(),
              decoration: const InputDecoration(
                hintText: "Search ",
                border: InputBorder.none,
                icon: Icon(Icons.search),
              ),
            ),
          ),

            // Featured Jobs header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text("Featured jobs",
                      style: TextStyle(fontWeight: FontWeight.bold,fontSize: 19,color: Color.fromARGB(255, 0, 145, 73))),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AllJobsScreen()),
                    );
                  },
                  child: const Text("See All",style: TextStyle(color: Color.fromARGB(255, 0, 145, 73)),),
                ),
              ],
            ),

            // Featured Job Card full width
            const JobCard(
              job: {
                "title": "Senior UI Designer",
                "company": "Gojek - Jakarta, ID",
                "salary": "\$70K - \$90K",
                "tags": ["Illustrator", "Social media", "Content data"],
                },
              ),


            const SizedBox(height: 12),

            // Categories Buttons
            Container(
              
              height: 40,
              color: Colors.white,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  categoryButton("All",onTap: (){} ),
                  categoryButton("Researcher",onTap:(){}),
                  categoryButton("UI Designer",onTap:(){}),
                  categoryButton("Developer",onTap:(){}),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Grid of Jobs with icons
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                childAspectRatio: 1.2,
                children: const [
                  JobTile(
                    title: "Machine Learning , AI",
                    icon: Icons.memory,
                  ),
                  JobTile(
                    title: "C# applications",
                    icon: Icons.code,
                  ),
                  JobTile(
                    title: "Figma UI/UX designer",
                    icon: Icons.design_services,
                  ),
                  JobTile(
                    title: "Machine Learning , AI",
                    icon: Icons.computer,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      
    );
  }
}