//
//  TimerView.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 06/01/2024.
//

import SwiftUI

struct TimerView: View {
    @EnvironmentObject var timerModel: TimerModel
    var body: some View {
        ZStack {
            //background
            Color(.black)
                .opacity(0.85)
                .ignoresSafeArea(.all)
                .frame(maxWidth: .infinity)
                .frame(maxHeight: .infinity)
            VStack {
                //title
                Text("Rest Timer")
                    .font(.title2.bold())
                    .foregroundColor(.white)
                    .padding(.top, 30)
                
                GeometryReader{proxy in VStack(spacing: 15)
                    {
                        ZStack{
                            //timer design
                            Circle()
                                .fill(.greenx2.opacity(0.0525))
                                .padding(-40)
                            
                            Circle()
                                .trim(from: 0, to: timerModel.progress)
                                .stroke(Color.greenx2.opacity(0.025), lineWidth: 80)
                            
                            
                            Circle()
                                .stroke(Color.greenx2.opacity(0.99), lineWidth: 5)
                                .blur(radius: 15)
                                .padding(-2)
                            
                            
                            Circle()
                                .fill(Color.black)
                            
                            Circle()
                                .trim(from: 0, to: timerModel.progress)
                                .stroke(Color.greenx2.opacity(0.7), lineWidth: 10)
                            
                            GeometryReader{proxy in let size = proxy.size
                                
                                Circle()
                                    .fill(Color.greenx2)
                                    .opacity(0.7)
                                    .frame(width: 30, height: 30)
                                    .overlay(content: {
                                        Circle()
                                            .fill(.black)
                                            .padding(5)
                                    })
                                    .frame(width: size.width, height: size.height, alignment: .center)
                                    .offset(x: size.height / 2)
                                    .rotationEffect(.init(degrees: timerModel.progress * 360))
                            }
                            Text(timerModel.timerStringValue)
                                .font(.system(size: 45, weight: .light))
                                .rotationEffect(.init(degrees: 90))
                                .animation(.none, value: timerModel.progress)
                            
                        }.padding(60)
                            .frame(height: proxy.size.width)
                            .rotationEffect(.init(degrees: -90))
                            .animation(.easeInOut, value: timerModel.progress)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                        
                        Button {
                            if timerModel.isStarted {
                                timerModel.stopTimer()
                            }else {
                                timerModel.addNewTimer = true
                            }
                        } label: {
                            Image(systemName: !timerModel.isStarted ? "play" : "pause")
                                .font(.largeTitle.bold())
                                .foregroundColor(.white)
                                .frame(width:80, height: 80)
                                .background{
                                    Circle()
                                        .fill(Color.greenx2)
                                        .opacity(0.8)
                                }
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                }
            }
            .padding()
            .overlay(content: {
                ZStack{
                    // Tapping on the overlay resets the minutes and seconds to 0 and hides the addNewTimer flag
                    Color.black
                        .opacity(timerModel.addNewTimer ? 0.25 : 0)
                        .onTapGesture {
                            timerModel.minutes = 0
                            timerModel.seconds = 0
                            timerModel.addNewTimer = false
                        }
                    
                    NewTimerView()
                        .frame(maxHeight: .infinity, alignment: .bottom)
                        .offset(y: timerModel.addNewTimer ? 0: 400)
                }
                .animation(.easeInOut, value: timerModel.addNewTimer)
            })
            .preferredColorScheme(.dark)
            // Updates the timerModel every second if the timer is started, triggering the updateTimer method
            .onReceive(Timer.publish(every: 1, on: .main, in: .common).autoconnect()) {
                _ in
                if timerModel.isStarted {
                    timerModel.updateTimer()
                    
                }
            }
        }
    }
    
    @ViewBuilder
    func NewTimerView()->some View {
        VStack(spacing: 15){
            Text("Start New Timer")
                .font(.title2.bold())
                .foregroundColor(.white)
                .padding(.top, 10)
            
            HStack(spacing: 15){
                Text("\(timerModel.minutes) min")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.gray.opacity(0.4))
                    }
                // Context menu options for setting the minutes value of the timer
                    .contextMenu{
                        ContextMenuOptions(maxValue: 6, hint: "min") { value in timerModel.minutes = value
                        }
                    }.foregroundStyle(Color.white)
                    .background(Color.black)
                
                Text("\(timerModel.seconds) sec")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.gray)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 12)
                    .background{
                        Capsule()
                            .fill(.gray.opacity(0.4))
                    }.contextMenu{
                        ContextMenuOptions(maxValue: 60, hint: "sec") { value in timerModel.seconds = value
                        }
                    }.preferredColorScheme(.dark)
                
            }.padding(.top, 20)
            
            Button {
                timerModel.startTimer()
            } label: {
                Text("Start")
                    .font(.title3)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .padding(.horizontal, 80)
                    .background{
                        Capsule()
                            .fill(Color.greenx2)
                    }
            }
            // Disable the context menu options if the minutes value of the timer is 0
            .disabled(timerModel.minutes == 0)
            .opacity(timerModel.minutes == 0 ? 0.5 : 1)
            .padding(.top)
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background{
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .fill(Color.black)
                .ignoresSafeArea()
        }
    }
    @ViewBuilder
    func ContextMenuOptions(maxValue: Int,hint: String, onClick: @escaping (Int)->())->some View{
        ForEach(0...maxValue,id: \.self){value in
            // Creates a button with a title consisting of the value and the hint
            Button("\(value) \(hint)"){
                onClick(value)
            }
        }
    }
}

#Preview {
    TimerView()
        .environmentObject(TimerModel())
}
