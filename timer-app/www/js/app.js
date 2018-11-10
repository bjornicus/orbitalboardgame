// Init F7 Vue Plugin
Framework7.use(Framework7Vue);

// Init Page Components
Vue.component('page-about', {
  template: '#page-about'
});
Vue.component('page-form', {
  template: '#page-form'
});
Vue.component('page-dynamic-routing', {
  template: '#page-dynamic-routing'
});
Vue.component('page-not-found', {
  template: '#page-not-found'
});

// Init App
function initApp() {
  new Vue({
    el: '#app',
    data: function() {
      return {
        secondsRemaining: 60,
        roundLength: 60,
        interval: false,
        hasTimeExpiredMessagePlayed: false,
        ships: [
          { color: 'green', isActive: true },
          { color: 'blue', isActive: true },
          { color: 'purple', isActive: true },
          { color: 'red', isActive: true },
          { color: 'orange', isActive: true },
          { color: 'yellow', isActive: true }
        ],
        malfuctions: [
          'has a fuel leak and loses one fuel',
          'has dysentery and is unable to move',
          'has broken its tooling and must retool'
        ],
        roundModifiers: [
          'Extreme solar activity is disrupting communications, players may not communicate with each other this round.'
        ],
        // Framework7 parameters here
        f7params: {
          root: '#app', // App root element
          id: 'io.framework7.testapp', // App bundle ID
          name: 'Framework7', // App name
          theme: 'auto', // Automatic theme detection
          // App routes
          routes: [
            {
              path: '/about/',
              component: 'page-about'
            },
            {
              path: '(.*)',
              component: 'page-not-found'
            }
          ]
        }
      };
    },
    computed: {
      gaugeValue: function() {
        return this.secondsRemaining / this.roundLength;
      },
      activeShips: function() {
        return this.ships.filter(s => s.isActive);
      },
      isRunning: function() {
        return !!this.interval;
      }
    },
    methods: {
      updateRoundLength: function(value) {
        this.roundLength = value;
        this.secondsRemaining = value;
      },
      toggleTimer: function() {
        if (this.interval) {
          this.stopTimer();
        } else {
          this.startTimer();
        }
      },
      startTimer: function() {
        if (Math.random() < 0.1) {
          var modifier = randomChoice(this.roundModifiers);
          speak(modifier);
        }
        this.interval = setInterval(() => {
          this.secondsRemaining = this.secondsRemaining - 0.2;
          if (this.secondsRemaining < 0 && !this.hasTimeExpiredMessagePlayed) {
            this.hasTimeExpiredMessagePlayed = true;
            var ship = randomChoice(this.activeShips);
            var malfunction = randomChoice(this.malfuctions);
            speak(`the ${ship.color} ship ${malfunction}`);
          }
        }, 200);
      },
      stopTimer: function() {
        clearInterval(this.interval);
        this.interval = false;
        this.secondsRemaining = this.roundLength;
        this.hasTimeExpiredMessagePlayed = false;
      }
    }
  });
}

initApp();

function randomChoice(choices) {
  return choices[Math.floor(Math.random() * choices.length)];
}

function speak(message) {
  if (speechSynthesis.speaking) {
    console.error('speechSynthesis.speaking');
    return;
  }
  if (message !== '') {
    var utterThis = new SpeechSynthesisUtterance(message);
    utterThis.onend = function(event) {
      console.log('SpeechSynthesisUtterance.onend');
    };
    utterThis.onerror = function(event) {
      console.error('SpeechSynthesisUtterance.onerror');
    };
    // var selectedOption = voiceSelect.selectedOptions[0].getAttribute('data-name');
    // for (i = 0; i < voices.length; i++) {
    //   if (voices[i].name === selectedOption) {
    //     utterThis.voice = voices[i];
    //   }
    // }
    // utterThis.pitch = pitch.value;
    // utterThis.rate = rate.value;
    speechSynthesis.speak(utterThis);
  }
}
