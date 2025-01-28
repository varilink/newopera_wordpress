import MyButton from './components/button';
import DatePicker from './components/date-picker';
import {
    DateTimePicker, Dropdown, Flex, FlexBlock, PanelRow
} from '@wordpress/components';
import { compose } from '@wordpress/compose';
import {
    dispatch, select, subscribe, withDispatch, withSelect
} from '@wordpress/data';
import { PluginDocumentSettingPanel } from '@wordpress/edit-post';
import { render } from '@wordpress/element';
import { registerPlugin } from '@wordpress/plugins';

// Scalable Vector Graphics path to produce the cross icon for closing dialogs
const cross_svg_path=
    'M12 13.06l3.712 3.713 1.061-1.06L13.061 12l3.712-3.712-1.06-1.06L12 ' +
    '10.938 8.288 7.227l-1.061 1.06L10.939 12l-3.712 3.712 1.06 1.061L12 ' +
    '13.061z';

const UpcomingProductionPanel = ( { metaFields, setMetaFields } ) => {

    const start_date = metaFields._upcoming_production_start_date;

    const end_date =  metaFields._upcoming_production_end_date;

    const tomorrow = () => {

        let today = new Date();
        let tomorrow = new Date(today);
        tomorrow.setDate(today.getDate() + 1);
        let year = tomorrow.getFullYear();
        let month = (tomorrow.getMonth() + 1).toString().padStart(2, '0');
        let day = tomorrow.getDate().toString().padStart(2, '0');
        return `${year}-${month}-${day}`;

    }

    return (

        <PluginDocumentSettingPanel
            name="production-dates-panel"
            title="Date(s)"
            icon="calendar"
            initialOpen={true}
        >
            <PanelRow>
                <Flex>
                    <FlexBlock>
                        <label>Start</label>
                    </FlexBlock>
                    <FlexBlock>
                        <Dropdown
                            renderToggle={ ( { isOpen, onToggle } ) => (
                                <MyButton
                                    date={
                                        metaFields._upcoming_production_start_date
                                        || ''
                                    }
                                    prompt='Select start date'
                                    onClick={ onToggle }
                                    aria-expanded={ isOpen }
                                />
                            ) }
                            renderContent={ ( { isOpen, onToggle } ) => {

                                const updateMetaField = ( newDate ) => {

                                    setMetaFields( {
                                        _upcoming_production_start_date:
                                            newDate.substring(0, 10)
                                    } );

                                }

                                return (
                                    <DatePicker
                                        initialDate={
                                            start_date ? start_date : (
                                                end_date ? end_date :
                                                    tomorrow()
                                            )
                                        }
                                        updateMetaField={ updateMetaField }
                                    />
                                );

                            } }
                        />
                    </FlexBlock>
                </Flex>
            </PanelRow>
            <PanelRow>
                <Flex>
                    <FlexBlock>
                        <label>End</label>
                    </FlexBlock>
                    <FlexBlock>
                        <Dropdown
                            renderToggle={ ( { isOpen, onToggle } ) => (
                                <MyButton
                                    date={
                                        metaFields._upcoming_production_end_date
                                        || ''
                                    }
                                    prompt='Select end date'
                                    onClick={ onToggle }
                                    aria-expanded={ isOpen }
                                />
                            ) }
                            renderContent={ ( { isOpen, onToggle } ) => {

                                const updateMetaField = ( newDate ) => {
                                    setMetaFields( {
                                        _upcoming_production_end_date: newDate
                                    } );
                                }

                                return (

                                    <DatePicker
                                        initialDate={
                                            end_date ? end_date : (
                                                start_date ? start_date :
                                                    tomorrow()
                                            )
                                        }
                                        updateMetaField={ updateMetaField }
                                    />
                                );

                            } }
                        />
                    </FlexBlock>
                </Flex>
            </PanelRow>
        </PluginDocumentSettingPanel>

    );

}

const applyWithSelect = withSelect( select => {
    return {
        metaFields: select( 'core/editor' ).getEditedPostAttribute( 'meta' )
    };
} );

const applyWithDispatch = withDispatch( dispatch => {
    return {
        setMetaFields ( newValue ) {
            dispatch('core/editor').editPost( { meta: newValue } )
        }
    }
} );

registerPlugin( 'upcoming-production-panel', {
    render: compose(
        applyWithSelect, applyWithDispatch
    )( UpcomingProductionPanel )
} );

// Validation of the event dates on trying to publish an FoBV event post type

let wasSavingPost = false; // on initial load the editor won't be saving

const validateDates = subscribe( () =>

    {

        const editor = select('core/editor');

        if (
            ! wasSavingPost &&
            editor.isSavingPost() && ! editor.isAutosavingPost() &&
            editor.getEditedPostAttribute('status') === 'publish'
        ) {

            wasSavingPost = true;

        } else if (
            wasSavingPost && ! editor.isSavingPost() &&
            editor.getEditedPostAttribute('status') === 'publish'
        ) {

            wasSavingPost = false;
            // Either the unsaved edit if one exists has a state of 'publish' or
            // the last known saved state of the post has a state of 'publish'.

            const start_date = editor.getEditedPostAttribute('meta').
                _upcoming_production_start_date;
            const end_date = editor.getEditedPostAttribute('meta').
                _upcoming_production_end_date;
            const today = new Date().toISOString().substring(0, 10);

            let message = null;

            if ( ! start_date ) {

                message = 'You can NOT publish an upcoming production'
                    + ' with no start date.';

            } else if ( start_date <= today ) {

                message = 'You can NOT publish an upcoming production'
                    + ' with a start date earlier than tomorrow.';

            } else if ( end_date && end_date < start_date ) {

                message = 'You can NOT publish an upcoming production'
                    + ' with an end date earlier than the start date.';

            } else if ( end_date && end_date <= today ) {

                message = 'You can NOT publish an upcoming production'
                    + ' with an end date earlier than tomorrow.';

            }

            if ( message ) {

                message
                    += ' This production has been saved, but reverted to draft.'
                    +  ' Correct this error to publish the production.'
                dispatch('core/editor').editPost( { status: 'draft' } );
                dispatch('core/editor').savePost();
                dispatch('core/notices').createErrorNotice(message);
                document.querySelector(
                    '.components-editor-notices__dismissible'
                ).scrollIntoView();

            }

        }
    },
    'core' // only subscribe to state change of the core data module
);
