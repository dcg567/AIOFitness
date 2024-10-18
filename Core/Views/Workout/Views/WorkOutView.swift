import SwiftUI

struct WorkOutView: View {
    @State private var isShowingTrackView = false
    @State private var showLeaderboardPopover = false
    @State private var showAchievementsPopover = false
    @State private var isShowingProgressView = false
    let yourFirestoreService = YourFirestoreService()
    
    var body: some View {
        NavigationView {
            ZStack {
                Color(.bGgrey)
                    .ignoresSafeArea(.all)
                    .frame(maxWidth: .infinity)
                    .frame(maxHeight: .infinity)
                VStack {
                    HStack {
                        Text("Workout")
                            .font(.system(size: 36, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(.leading, 1)
                            .padding(.trailing, 120)
                        
                        HStack{
                            Button(action: {
                                showLeaderboardPopover.toggle()
                            }) {
                                Image(systemName: "trophy.circle")
                                    .font(Font.system(size: 25))
                                    .imageScale(.large)
                                    .foregroundColor(Color.greenx2)
                                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                            }.popover(isPresented: $showLeaderboardPopover, content: {
                                LeaderboardView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.bGgrey)
                            })
                            
                            Button(action: {
                                showAchievementsPopover.toggle()
                            }) {
                                Image(systemName: "shield.righthalf.filled")
                                    .font(Font.system(size: 25))
                                    .imageScale(.large)
                                    .foregroundColor(Color.greenx2)
                                    .shadow(color: Color.black.opacity(0.15), radius: 3, x: -2, y: 2)
                                
                            }
                            .popover(isPresented: $showAchievementsPopover, content: {
                                AchievementsView()
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(Color.bGgrey)
                            })
                        }
                        
                    }.padding(.bottom, -30)
                        .padding(.top, -70)
                    
                    Text("Exercises")
                        .font(.title2)
                        .foregroundStyle(Color.white)
                        .fontWeight(.semibold)
                        .padding(.top, -5)
                        .padding(.bottom, 2)
                        .padding(.leading, -170)
                        .font(.title)
                    
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(workoutItems) { item in
                                WorkoutCard(imageName: item.imageName, title: item.title, destination: item.destination)
                                    .padding()
                                    .padding(.trailing, -35)
                                    .padding(.leading, 10)
                            }
                        }
                    }.navigationBarBackButtonHidden()
                        .padding(.top, -20)
                        .scrollIndicators(.hidden)
                    
                    WOCategoriesView(firestoreService: YourFirestoreService())
                    
                    Button(action: {
                        isShowingTrackView.toggle()
                    }) {
                        ZStack {
                            Capsule()
                                .fill(Color.greenx2)
                                .frame(width:340, height: 65)
                                .padding(.bottom, -30)
                            HStack {
                                Text("Track Workout")
                                    .font(.title)
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                                    .padding()
                                
                                ZStack{
                                    Image(systemName: "circle.fill")
                                        .font(Font.system(size: 35))
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.bGgrey)
                                    
                                    Image(systemName: "plus.circle.fill")
                                        .font(Font.system(size: 35))
                                        .imageScale(.large)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.white)
                                }
                            }.padding(.top, 30)
                        }.padding(.top, 2.5)
                            .padding(.bottom, -40)
                        
                    }.popover(isPresented: $isShowingTrackView) {
                        TrackWOView()
                    }
                    
                }.scrollIndicators(.hidden)
                    .padding(.top, 10)
            }
        }
    }
}
#Preview {
    WorkOutView()
}

