//
//  ExerciseDetailViewBuilder.swift
//  AIOFitness
//
//  Created by David Ghiurcan on 17/01/2024.
//
//exercise info
import SwiftUI

struct ExerciseDetailViewBuilder {
    
    static func getDestinationView(for exercise: String) -> some View {
        switch exercise {
            //CHEST
        case "Bench Press":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "BENCH PRESS",
                imageName: "bench",
                instructions: " Lie on a flat bench with your feet planted firmly on the ground. Grip the barbell with hands shoulder-width apart, lower it to your chest, then push it back up to the starting position, fully extending your arms.",
                repSetRange: "3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/vcBig73ojpE?si=YNEw-p05mz7_sP9H")))
        case "Chest Press":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "CHEST PRESS",
                imageName: "chestpress",
                instructions: "Sit on a chest press machine with your feet flat on the ground. Grip the handles with hands shoulder-width apart, push them forward until your arms are fully extended, then slowly bring them back towards your chest.",
                repSetRange: "3 sets x 5 - 8 reps",
                videoLink: "https://www.youtube.com/watch?v=sqNwDkUU_Ps&ab_channel=PureGym")))
        case "Pec Deck":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "PEC DECK",
                imageName: "pecdeck",
                instructions: "Sit on a pec deck machine with your back against the pad and feet flat on the ground. Place your forearms against the pads and push them together in front of your chest, then slowly release them back out to the sides.",
                repSetRange: "3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/O-OBCfyh9Fw?si=fYSiZBai0sC2h6L0")))
        case "Chest Fly":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "CHEST FLY",
                imageName: "fly",
                instructions: "Lie on a flat bench with a dumbbell in each hand, arms extended above your chest. Lower the dumbbells out to the sides in a wide arc until your arms are parallel to the ground, then bring them back together over your chest.",
                repSetRange: "3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/QENKPHhQVi4?si=_9AlFwGcioPkyrea")))
        case "Dips":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "DIPS",
                imageName: "dips",
                instructions: "Grip the bars with hands shoulder-width apart, lift yourself up until your arms are straight, then lower your body by bending your elbows until your upper arms are parallel to the ground. Push yourself back up to the starting position.",
                repSetRange: "3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/yN6Q1UI_xkE?si=s9CRIHzDiWVYTOP7")))
            
            
            //LEGS
        case "Squat":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "SQUATS",
                imageName: "squat",
                instructions: "Stand with feet shoulder-width apart, hold a barbell across your upper back. Lower your body by bending your knees and hips, keeping your back straight, until your thighs are parallel to the ground, then push through your heels to return to the starting position.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/Uv_DKDl7EjA?si=0Cv2APCts4MtzNz9")))
        case "Leg Press":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "LEG PRESS",
                imageName: "legpress",
                instructions: "Sit  with feet shoulder-width apart on the platform. Push the platform away by extending your knees until your legs are almost straight, then slowly lower it back down with control.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/s9-zeWzPUmA?si=88apgX55CVWMpURs")))
        case "RDL":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "RDL",
                imageName: "rdlform",
                instructions: "Stand with feet hip-width apart, hold a barbell in front of your thighs with an overhand grip. Keeping your back straight, hinge at the hips and lower the barbell towards the ground while keeping it close to your body, then return to the starting position by squeezing your glutes and hamstrings.",
                repSetRange: "2-3 sets x 6 - 10 reps",
                videoLink: "https://youtu.be/_oyxCn2iSjU?si=CnVA9lZC-GySCtkY")))
        case "Leg Extension":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "LEG EXTENSION",
                imageName: "legex",
                instructions: "Sit on a leg extension machine with your knees bent at a 90-degree angle. Extend your legs to lift the weight until your knees are straight, then lower it back down with control.",
                repSetRange: "2-3 sets x 5 - 12 reps",
                videoLink: "https://youtu.be/ljO4jkwv8wQ?si=sMdtOhRR91Nux467")))
        case "Hamstring Curl":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "HAMSTRING CURLS",
                imageName: "hscurl",
                instructions: "Lie face down on a hamstring curl machine with your ankles hooked under the padded lever. Curl your heels towards your glutes by flexing your knees, then slowly lower them back down.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/oFxEDkppbSQ?si=7jbY6ru8FEd3AeFv")))
        case "Calf Raise":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "CALF RAISE",
                imageName: "calfraise",
                instructions: "Stand on a calf raise machine with your shoulders under the pads and balls of your feet on the platform. Lift your heels as high as possible by extending your ankles, then lower them back down with control.",
                repSetRange: "2-4 sets x 8 - 12 reps",
                videoLink: "https://youtu.be/g_E7_q1z2bo?si=p1u-UTO-M3qiWTyW")))
        case "Lunges":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "LUNGE",
                imageName: "lunge",
                instructions: "Stand with feet hip-width apart, step forward with one leg and lower your body until both knees are bent at a 90-degree angle, then push back up to the starting position. Repeat on the other leg.",
                repSetRange: "2-3 sets x 6 - 12 reps",
                videoLink: "https://youtu.be/eFWCn5iEbTU?si=xD3a51BM-6-pDTZ1")))
        //Arms
            
        case "Barbell Curl":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Barbell Curl",
                imageName: "bbcurl",
                instructions: " Stand with feet shoulder-width apart, hold a barbell with an underhand grip, hands slightly wider than shoulder-width apart. Curl the barbell up towards your shoulders while keeping your elbows close to your body, then lower it back down with control.",
                repSetRange: "2-3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/JnLFSFurrqQ?si=cREs85vZhHO9Z_yc")))
        case "Skull Crusher":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Skull Crusher",
                imageName: "skulls",
                instructions: "Lie on a flat bench with a barbell/db in your hands, arms extended above your chest. Bend your elbows to lower the barbell/db towards your forehead, then extend your arms to lift it back up to the starting position.",
                repSetRange: "3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/jO2Jl9eZpXk?si=ZbD18ObqLQBaP5gl")))
        case "Hammer Curl":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Hammer Curl",
                imageName: "hammer",
                instructions: "Stand with feet shoulder-width apart, hold dumbbells in each hand with palms facing towards your body. Curl the dumbbells up towards your shoulders while keeping your palms facing in, then lower them back down with control.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/7jqi2qWAUJk?si=JIvYhqxiEmQYcrk9")))
        case "Incline Curl":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Incline Curl",
                imageName: "inclinecurl",
                instructions: "Sit on an incline bench with a dumbbell in each hand, arms extended down by your sides. Curl the dumbbells up towards your shoulders while keeping your elbows close to your body, then lower them back down with control.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/aTYlqC_JacQ?si=Fy-Bxb0s-Mb86ybS")))
        case "Pushdowns":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Pushdowns",
                imageName: "pushdown",
                instructions: "Stand tall with feet shoulder-width apart, hold a cable attachment with an overhand grip. Keep your elbows close to your body as you push the attachment down towards your thighs, then slowly release it back up to the starting position.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/6Fzep104f0s?si=6Ld9e8gfYOan4QGe")))
        
        //Delts
        
        case "Lateral Raise":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Lateral Raise",
                imageName: "lraise",
                instructions: "Hold dumbbells in each hand by your sides with palms facing in. Lift the dumbbells out to the sides until they reach shoulder height, then lower them back down with control.",
                repSetRange: "2 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/Gmi_DCnJ93c?si=b2iQi7fX-SVKEeTn")))
        case "Reverse Fly":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Reverse Fly",
                imageName: "dbrevfly",
                instructions: "Hold dumbbells in each hand with palms facing each other. Bend forward at the hips, keeping a slight bend in the knees. Lift the dumbbells out to the sides until they reach shoulder height, then lower them back down with control.",
                repSetRange: "2 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/5YK4bgzXDp0?si=kZbWly-JmNqqCRR1")))
        case "Shoulder Press":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Shoulder Press",
                imageName: "spress",
                instructions: "Sit on a bench with back support, hold dumbbells at shoulder height with palms facing forward (elbows in at a slight angle). Press the dumbbells overhead until arms are fully extended, then lower them back down to shoulder height with control.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/nHboL27_Sn0?si=q0_Mlb2NTuAbKUxz")))
        case "Front Raise":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Front Raise",
                imageName: "dbfrontraise",
                instructions: "Stand with feet shoulder-width apart, hold dumbbells in front of thighs with palms facing your body. Lift the dumbbells directly in front of you until they reach shoulder height, then lower them back down with control.",
                repSetRange: "2 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/-t7fuZ0KhDA?si=PpyBzuuiacnZFqKT")))
        case "Military Press":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Military Press",
                imageName: "mpress",
                instructions: "Hold a barbell at shoulder height with an overhand grip slightly wider than shoulder-width (or whatever is comfortable). Press the barbell overhead until arms are fully extended, then lower it back down to shoulder height with control.",
                repSetRange: "2-3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/d2uus7QUt4c?si=WmBXLnBSEeADuLIL")))
            
        //Back
        
        case "Pull Up":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Pull Up",
                imageName: "pullup",
                instructions: "Hang from a bar with your palms facing away and hands shoulder-width apart. Pull yourself up until your chin passes the bar, then lower yourself back down with control.",
                repSetRange: "2-3 sets x 6 - 12 reps",
                videoLink: "https://youtu.be/XB_7En-zf_M?si=eK3U-Nnpx-YfNNru")))
        case "Deadlift":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Deadlift",
                imageName: "deadlift",
                instructions: "Stand with feet hip-width apart, bend at the hips and knees to grip the barbell with hands shoulder-width apart. Keep your back straight as you lift the barbell by straightening your hips and knees until standing upright, then lower it back down with control.",
                repSetRange: "1-3 sets x 3 - 8 reps",
                videoLink: "https://youtu.be/VL5Ab0T07e4?si=gVvVVVBbcKkPwqTo")))
        case "Lat Pulldown":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Lat Pulldown",
                imageName: "latpd",
                instructions: "Sit at a lat pulldown machine with a grip attachment of choice. Pull the bar down to your chest (slightly above/lower is also ok) while leani g back slightly, then slowly release it back up.",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/trZQjegcRx0?si=FB_Zf4Tm8dtG4CId")))
        case "Barbell Row":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Barbell Row",
                imageName: "row",
                instructions: " Stand with feet hip-width apart, bend at the hips and knees to grip the barbell with hands shoulder-width apart. Keep your back straight as you pull the barbell up towards your chest, then lower it back down with control",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/7B5Exks1KJE?si=SmUCHIKLwno-7pO1")))
        case "Machine Row":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "Machine Row",
                imageName: "mrow",
                instructions: "Sit with your chest against the pad and feet securely on the footrests. Grab the handles with grip of choice, pull the handles towards your torso while squeezing your shoulder blades together, then slowly release them back out to get a full stretch on the ecentric",
                repSetRange: "2-3 sets x 5 - 10 reps",
                videoLink: "https://youtu.be/TeFo51Q_Nsc?si=VH7ag6PKY5Aepo3S")))
        
        case "T-Bar Row":
            return AnyView(ExerciseDetailView(exercise: Exercise(
                name: "T-Bar Row",
                imageName: "tbar",
                instructions: "Stand with feet shoulder-width apart, straddle the T-bar machine and grip the handles with both hands. Keep your back straight as you pull the handles towards your torso (think about pinching your upper back), then control the ecentric to get a full stretch.",
                repSetRange: "2-3 sets x 5 - 8 reps",
                videoLink: "https://youtu.be/7B5Exks1KJE?si=SmUCHIKLwno-7pO1")))
        
        default:
            return AnyView(Text("Default Detail View"))
        }
    }
}

