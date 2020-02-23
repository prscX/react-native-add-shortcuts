<h1 align="center">

  <p align="center">
    <a href="https://www.npmjs.com/package/react-native-add-shortcuts"><img src="http://img.shields.io/npm/v/react-native-add-shortcuts.svg?style=flat" /></a>
    <a href="https://github.com/prscX/react-native-add-shortcuts/pulls"><img alt="PRs Welcome" src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg" /></a>
    <a href="https://github.com/prscX/react-native-add-shortcuts#License"><img src="https://img.shields.io/npm/l/react-native-add-shortcuts.svg?style=flat" /></a>
  </p>

    ReactNative: Native Add Shortcuts Library (Android/iOS)

If this project has helped you out, please support us with a star 🌟

</h1>

This library is a React Native bridge around native API's providing capability to add app shortcuts.

> This library is support RN61+

## 📖 Getting started

`$ npm install react-native-add-shortcuts --save`

- Add `react-native-image-helper` your app package.json

`$ npm install react-native-image-helper --save`

- Add `react-native-vector-icons` to your app package.json and configure it as per their installation steps

`$ npm install react-native-vector-icons --save`

- **iOS**

> **iOS Prerequisite:** Please make sure `CocoaPods` is installed on your system

    - Add the following to your `Podfile` -> `ios/Podfile` and run pod update:

```
  use_native_modules!

  pod 'RNAddShortcuts', :path => '../node_modules/react-native-add-shortcuts/ios'
```

- **Android**

> No configuration is required

## 🎨 Usage

- Add Pinned Shortcut

> **Note**: Only support on Android Platform

```
import { RNAddShortcuts } from 'react-native-add-shortcuts'

let copy = (
    <Icon
    name="copy"
    size={30}
    color="#000000"
    family={'FontAwesome'}
    />
)

RNAddShortcuts.AddPinnedShortcut({
    label: 'Copy',
    description: 'Copy Desc',
    icon: copy,
    link: 'app:copy',
    onDone: () => {
        console.log('Shortcut Added');
    }
})

```

- Add Dynamic Shortcut

```
import { RNAddShortcuts } from 'react-native-add-shortcuts'

let copy = (
    <Icon
    name="copy"
    size={30}
    color="#000000"
    family={'FontAwesome'}
    />
);

RNAddShortcuts.AddDynamicShortcut({
    label: 'Copy',
    description: 'Copy Desc',
    icon: 'copy.png',
    link: 'app:copy',
    onDone: () => {
        console.log('Shortcut Added');
    }
});

```

- Get Dynamic Shortcuts

```
import { RNAddShortcuts } from 'react-native-add-shortcuts'

RNAddShortcuts.GetDynamicShortcuts({
    onDone: shortcuts => {
        console.log('Shortcuts: ' + shortcuts);
    }
});

```

- Remove All Dynamic Shortcuts

```
import { RNAddShortcuts } from 'react-native-add-shortcuts'

RNAddShortcuts.RemoveAllDynamicShortcuts({
    onDone: () => {
        console.log('All Dynamic Shortcuts Removed');
    }
})

```

- Pop Dynamic Shortcuts

```
import { RNAddShortcuts } from 'react-native-add-shortcuts'

RNAddShortcuts.PopDynamicShortcuts({
    shortcuts: ['Copy'],
    onDone: () => {
        console.log('Pop Dynamic Shortcuts');
    }
})

```

## 💡 Props

- **General(iOS & Android)**

| Prop                            | Type   | Default | Note                                                      |
| ------------------------------- | ------ | ------- | --------------------------------------------------------- |
| `AddPinnedShortcut({})`         | `func` |         | Add Pinned Shortcut (Only supported for Android Platform) |
| `AddDynamicShortcut({})`        | `func` |         | Add Dynamic Shortcut                                      |
| `GetDynamicShortcuts({})`       | `func` |         | Get All Dynamic Shortcut                                  |
| `RemoveAllDynamicShortcuts({})` | `func` |         | Remove All Dynamic Shortcuts                              |
| `PopDynamicShortcuts({})`       | `func` |         | Delete Specific Dynamic Shortcuts                         |

## ✨ Credits

## 🤔 How to contribute

Have an idea? Found a bug? Please raise to [ISSUES](https://github.com/prscX/react-native-add-shortcuts/issues).
Contributions are welcome and are greatly appreciated! Every little bit helps, and credit will always be given.

## 💫 Where is this library used?

If you are using this library in one of your projects, add it in this list below. ✨

## 📜 License

This library is provided under the Apache 2 License.

RNAppTour @ [prscX](https://github.com/prscX)

## 💖 Support my projects

I open-source almost everything I can, and I try to reply everyone needing help using these projects. Obviously, this takes time. You can integrate and use these projects in your applications for free! You can even change the source code and redistribute (even resell it).

However, if you get some profit from this or just want to encourage me to continue creating stuff, there are few ways you can do it:

- Starring and sharing the projects you like 🚀
- If you're feeling especially charitable, please follow [prscX](https://github.com/prscX) on GitHub.

  <a href="https://www.buymeacoffee.com/prscX" target="_blank"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: auto !important;width: auto !important;" ></a>

  Thanks! ❤️
  <br/>
  [prscX.github.io](https://prscx.github.io)
  <br/>
  </ Pranav >
