/*
MIT License

Copyright (c) 2024 Michele Maione

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/
import 'package:cygnus2/data_structures/mad_data.dart';
import 'package:cygnus2/data_structures/my_data.dart';
import 'package:cygnus2/ui/base/clickable.dart';
import 'package:cygnus2/ui/mad/icon_chip.dart';
import 'package:cygnus2/ui/mad/mad_screen.dart';
import 'package:cygnus2/ui/mad/my_profile_picture.dart';
import 'package:cygnus2/utility/commons.dart';
import 'package:cygnus2/utility/utility.dart';
import 'package:flutter/material.dart';

class MadCard extends StatelessWidget {
  final MyData myProfile;
  final MadData mad;

  const MadCard({
    super.key,
    required this.mad,
    required this.myProfile,
  });

  bool get canContact => MadData.canContact(myProfile.madData, mad);

  @override
  Widget build(BuildContext context) {
    return Clickable(
      onTap: () => Commons.navigate<void>(
        context: context,
        builder: (context) => MadScreen(
          myProfile: myProfile,
          mad: mad,
        ),
      ),
      child: Card(
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture
              MyProfilePicture(
                nickname: mad.nickname,
                personId: mad.personId,
                size: 100,
              ),

              // space
              const SizedBox(width: 8),

              // data
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Nickname
                    if (canContact) ...[
                      IconChip(
                        icon: Icons.handshake,
                        color: Colors.orange,
                        labels: [mad.nickname],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else if (mad.isLikedByMe(myProfile.profileData!.idFirebase)) ...[
                      IconChip(
                        icon: Icons.thumb_up,
                        color: Colors.pink,
                        labels: [mad.nickname],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else if (mad.isDislikedByMe(myProfile.profileData!.idFirebase)) ...[
                      IconChip(
                        icon: Icons.thumb_down,
                        color: Colors.blueGrey,
                        labels: [mad.nickname],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ] else ...[
                      IconChip(
                        icon: Icons.person,
                        color: Colors.black,
                        labels: [mad.nickname],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],

                    // space
                    const SizedBox(height: 8),

                    // Age
                    IconChip(
                      icon: Icons.cake,
                      color: Colors.blue,
                      labels: [mad.ageS],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // University
                    IconChip(
                      icon: Icons.balance,
                      color: Colors.grey,
                      labels: [mad.university],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Department
                    IconChip(
                      icon: Icons.school,
                      color: Colors.brown,
                      labels: [mad.department],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Location
                    IconChip(
                      icon: Icons.location_pin,
                      color: Colors.red,
                      labels: [mad.distanceToS(myProfile.madData?.geoPoint)],
                    ),

                    // space
                    const SizedBox(height: 8),

                    // Bio
                    if (mad.bio != null && mad.bio!.isNotEmpty) ...[
                      IconChip(
                        icon: Icons.book,
                        color: Colors.green,
                        labels: [Utility.left(mad.bio, 50)],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
