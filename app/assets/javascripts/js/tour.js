var tour = {
    id: 'welcome-to-incomehawk',
    steps: [
        {
            target: 'dashboard-header',
            title: 'Estimated Income',
            content: 'Here you can see the expected income of the current and next month, based on all payments in the system. Click to see a per payment breakdown.',
            placement: 'bottom',
            arrowOffset: 160
        },
        {
            target: 'active-projects-list',
            title: 'Projects by Status',
            content: 'In the main Section you can see all project stats, grouped by the different project statuses: Active, Prospective, Lost, and Completed.',
            placement: 'right',
            yOffset: -40,
            arrowOffset: 50
        },
        {
            target: 'active-projects-header',
            placement: 'bottom',
            title: 'Overview',
            content: 'For each project group and for each project you can see, the amount of payments, their total value, how much has already been billed, and how much is still remaining.',
            arrowOffset: 80,
            xOffset: 150
        },
        {
            target: 'right-col',
            placement: 'left',
            title: 'Actions',
            content: 'Create new projects and contacts using these buttons.',
//            yOffset: -25
            xOffset: 40,
            arrowOffset: 40
        },
        {
            target: 'search-bar',
            placement: 'bottom',
            title: 'Universal Search',
            content: 'Quickly jump to project or contact pages',
            arrowOffset: 100
        },
        {
            target: 'main-body',
            placement: 'center',
            title: 'That’s it!',
            content: 'We’re done with the basic tour, play around with our app, and remember you can delete the Sample projects and payments from the account page.',
            xOffset: 'center',
            yOffset: 120
        }
    ],
    showPrevButton: true,
    scrollTopMargin: 100
}

$(document).ready( function() {
    $('#modal-start-tour').modal()
    $('.skip-tour-button').live('click', function(){
        $.modal.close()
    })
//    $('#start-tour').powerTour({
//        tourType: 'step',
//        overlayOpacity: 0.5,
//        showTimeControls: false,
//        showTimer: false,
//        timeButtonOrder: '%prev% %stop% %pause% %play% %next%',
//        stepButtonOrder: '%prev% %next% %stop%',
//        timerLabel: 'Next step in: ',
//        effectSpeed: 200,
//        travelSpeed: 400,
//        easingEffect: 'linear',
//        easyCancel: true,
//        animated: true,
//        animatedOnEnd:true,
//        keyboardNavigation: true,
//        runOnLoad: false,
//        runOnLoadDelay: 2000,
//        exitUrl: '',
//        onStart: function(){},
//        onFinish: function(){},
//        onStop: function(){},
//        onCancel: function(){},
//        step:[
//            {
//                hookTo: '#dashboard-header',
//                content: '#tour-estimated-income',
////                cloneTo: '',
//                width: 400,
//                arrowPosition: 'sc',
//                showArrow: false,
//                offsetY: 0,
//                offsetX: 0,
//                prevLabel: 'Prev',
//                nextLabel: 'Next',
//                stopLabel: 'Stop',
//                center: 'hook',
//                customClassStep: '',
//                customClassHook: '',
//                highlight: true,
//                highlightElements: '',
//                time: '00:05',
//                onShowStep: function(){},
//                onHideStep: function(){}
//            },
//            {
//                hookTo: '',
//                content: '#tour-project-status',
//                cloneTo: '',
//                width: 400,
//                arrowPosition: 'sc',
//                showArrow: false,
//                offsetY: 0,
//                offsetX: 0,
//                prevLabel: 'Prev',
//                nextLabel: 'Next',
//                stopLabel: 'Stop',
//                center: 'hook',
//                customClassStep: '',
//                customClassHook: '',
//                highlight: true,
//                highlightElements: '',
//                time: '00:05',
//                onShowStep: function(){},
//                onHideStep: function(){}
//            },
//        ]
//    });
    $('.start-tour-button').live('click', function(){
        hopscotch.startTour(tour);
        $.modal.close();
    })
});