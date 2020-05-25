/**
 * Sample React Native App
 * https://github.com/facebook/react-native
 * @flow
 */

import React, {Component} from 'react';
import {
  Platform,
  StyleSheet,
  Text,
  View,
  TouchableHighlight,
  ImageBackground,
  Button,
} from 'react-native';

import {RNAddShortcuts} from 'react-native-add-shortcuts';
import Icon from 'react-native-vector-icons/FontAwesome';

import paste from './assets/paste.png';

export default class App extends Component<{}> {
  render() {
    return (
      <ImageBackground
        source={require('./assets/dark.jpg')}
        style={styles.backgroundImage}>
        <Button
          title={'Add Pinned Shortcut'}
          onPress={() => {
            let copy = (
              <Icon
                name={'paste.png'}
                size={30}
                color="#000000"
                family={'FontAwesome'}
              />
            );

            RNAddShortcuts.AddPinnedShortcut({
              label: 'Paste',
              description: 'Copy Desc',
              icon: paste,
              link: {url: 'app:copy'},
              onDone: () => {
                console.log('Shortcut Added');
              },
            });
          }}></Button>
        <Button
          title={'Add Dynamic Shortcut'}
          onPress={() => {
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
              link: {url: 'app:copy'},
              onDone: () => {
                console.log('Shortcut Added');
              },
            });
          }}></Button>
        <Button
          title={'Get Dynamic Shortcuts'}
          onPress={() => {
            RNAddShortcuts.GetDynamicShortcuts({
              onDone: (shortcuts) => {
                console.log('Shortcuts: ' + shortcuts);
              },
            });
          }}></Button>
        <Button
          title={'Remove All Dynamic Shortcuts'}
          onPress={() => {
            RNAddShortcuts.RemoveAllDynamicShortcuts({
              onDone: () => {
                console.log('All Dynamic Shortcuts Removed');
              },
            });
          }}></Button>
        <Button
          title={'Pop Dynamic Shortcuts'}
          onPress={() => {
            RNAddShortcuts.PopDynamicShortcuts({
              shortcuts: ['Copy'],
              onDone: () => {
                console.log('Pop Dynamic Shortcuts');
              },
            });
          }}></Button>
      </ImageBackground>
    );
  }
}

const styles = StyleSheet.create({
  backgroundImage: {
    flex: 1,
    width: null,
    height: null,
    flexDirection: 'column',
    justifyContent: 'space-between',
  },
  textStyle: {
    color: '#FFFFFF',
  },
  top: {
    flex: 1,
  },
  center: {
    flex: 1,
  },
  bottom: {
    flex: 1,
  },
});
