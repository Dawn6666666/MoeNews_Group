<script setup>
const themeOverrides = {
  common: {
    primaryColor: '#FF6B8B',
    primaryColorHover: '#FF4773',
    primaryColorPressed: '#E03D5F',
    primaryColorSuppl: '#FFB6C1',
    infoColor: '#4EA8DE',
    infoColorHover: '#62B6E5',
    infoColorPressed: '#3A91C6',
    warningColor: '#FF8E3C',
    warningColorHover: '#FFA057',
    warningColorPressed: '#E07525',
    borderRadius: '8px',
    borderRadiusSmall: '6px',
    textColor1: '#2D3748',
    textColor2: '#4A5568',
    textColor3: '#718096',
    borderColor: '#F5E6F3',
    popoverColor: '#ffffff',
    cardColor: '#ffffff',
    modalColor: '#ffffff'
  },
  Button: {
    borderRadiusMedium: '8px',
    borderRadiusLarge: '12px',
    fontWeight: '600'
  },
  Card: {
    borderRadius: '16px',
    borderColor: '#F5E6F3',
    boxShadow: '0 12px 32px rgba(255, 107, 139, 0.09)'
  },
  Input: {
    borderRadius: '8px',
    borderHover: '1px solid #FF6B8B',
    borderFocus: '1px solid #FF6B8B',
    boxShadowFocus: '0 0 0 2px rgba(255, 107, 139, 0.15)'
  },
  Menu: {
    borderRadius: '8px',
    itemColorActive: '#FFF0F3',
    itemColorActiveHover: '#FFF0F3',
    itemTextColorActive: '#FF6B8B',
    itemTextColorActiveHover: '#FF4773',
    itemIconColorActive: '#FF6B8B',
    itemIconColorActiveHover: '#FF4773'
  },
  Tag: {
    borderRadius: '6px',
    fontWeight: '600',
    textColorCheckable: '#2D3748',
    textColorHoverCheckable: '#FF6B8B',
    textColorChecked: '#ffffff',
    colorChecked: '#FF6B8B',
    colorCheckedHover: '#FF4773',
    borderChecked: '1px solid #FF6B8B',
    borderCheckedHover: '1px solid #FF4773'
  },
  Pagination: {
    buttonBorderRadius: '8px',
    itemBorderRadius: '8px',
    itemColorActive: '#FFF0F3',
    itemColorActiveHover: '#FFF0F3',
    itemTextColorActive: '#FF6B8B',
    itemTextColorActiveHover: '#FF4773',
    itemBorderActive: '1px solid #FFD6E0'
  },
  Dialog: {
    borderRadius: '16px',
    iconColorWarning: '#FF8E3C'
  },
  Message: {
    borderRadius: '8px',
    boxShadow: '0 8px 24px rgba(255, 107, 139, 0.1)'
  }
}
</script>

<template>
  <n-config-provider :theme-overrides="themeOverrides">
    <n-message-provider>
      <n-dialog-provider>
        <router-view />
      </n-dialog-provider>
    </n-message-provider>
  </n-config-provider>
</template>
