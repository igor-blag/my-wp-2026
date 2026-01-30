import { registerBlockType } from '@wordpress/blocks';
import './style.scss'; // Если захочешь использовать SASS

registerBlockType( 'create-block/edu-staff-registry', {
    edit: () => <div { ...wp.blockEditor.useBlockProps() }>Hello from the Editor!</div>,
    save: () => <div { ...wp.blockEditor.useBlockProps.save() }>Hello from the Frontend!</div>,
} );