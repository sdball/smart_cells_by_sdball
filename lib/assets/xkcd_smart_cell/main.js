import * as Vue from "https://cdn.jsdelivr.net/npm/vue@3.2.26/dist/vue.esm-browser.prod.js";

export function init(ctx, info) {
  ctx.importCSS("main.css");
  ctx.importCSS("https://fonts.googleapis.com/css2?family=Inter:wght@400;500&display=swap");

  const app = Vue.createApp({
    template: `
    <div class="app">
      <h3>xkcd comic smart cell</h3>
      <form @change="handleFieldChange">
        <div class="container">
          <div class="row">
            <BaseSelect
              name="action"
              label="Fetch "
              v-model="fields.action"
              selectClass="input input--xs"
              :inline
              :options="fields.actions"
            />
          </div>
          <div class="row">
            <BaseInput
              name="number"
              label="Number"
              type="integer"
              placeholder="123"
              v-model="fields.number"
              inputClass="input"
              v-show="findComicByNumber()"
              :grow
            />
          </div>
        </div>
      </form>
    </div>
    `,

    data() {
      return {
        fields: info.fields,
      }
    },

    methods: {
      handleFieldChange(event) {
        if (event.target.type == "checkbox") {
          const { name, checked } = event.target;
          console.log([name, checked]);
          ctx.pushEvent("update_field", { field: name, checked });
        } else {
          const { name, value } = event.target;
          console.log([name, value]);
          ctx.pushEvent("update_field", { field: name, value });
        }
      },
      findComicByNumber() {
        console.log(this.fields.action);
        return this.fields.action === 'lookup'
      }
    },

    components: {
      BaseInput: {
        props: {
          label: {
            type: String,
            default: ''
          },
          inputClass: {
            type: String,
            default: 'input'
          },
          modelValue: {
            type: [String, Number],
            default: ''
          },
          inline: {
            type: Boolean,
            default: false
          },
          grow: {
            type: Boolean,
            default: false
          },
          number: {
            type: Boolean,
            default: false
          }
        },

        template: `
        <div v-bind:class="[inline ? 'inline-field' : 'field', grow ? 'grow' : '']">
          <label v-bind:class="inline ? 'inline-input-label' : 'input-label'">
            {{ label }}
          </label>
          <input
            :value="modelValue"
            @input="$emit('update:data', $event.target.value)"
            v-bind="$attrs"
            v-bind:class="[inputClass, number ? 'input-number' : '']"
          >
        </div>
        `
      },
      BaseTextArea: {
        props: {
          label: {
            type: String,
            default: ''
          },
          inputClass: {
            type: String,
            default: 'input'
          },
          modelValue: {
            type: [String, Number],
            default: ''
          },
          inline: {
            type: Boolean,
            default: false
          },
          grow: {
            type: Boolean,
            default: false
          },
          number: {
            type: Boolean,
            default: false
          }
        },

        template: `
        <div v-bind:class="[inline ? 'inline-field' : 'field', grow ? 'grow' : '']">
          <label v-bind:class="inline ? 'inline-input-label' : 'input-label'">
            {{ label }}
          </label>
          <textarea
            rows=10
            :value="modelValue"
            @input="$emit('update:data', $event.target.value)"
            v-bind="$attrs"
            v-bind:class="[inputClass, number ? 'input-number' : '']"
          >
        </div>
        `
      },
      BaseSelect: {
        name: "BaseSelect",
        props: {
          label: {
            type: String,
            default: ''
          },
          selectClass: {
            type: String,
            default: 'input'
          },
          modelValue: {
            type: String,
            default: ''
          },
          options: {
            type: Array,
            default: [],
            required: true
          },
          required: {
            type: Boolean,
            default: false
          },
          inline: {
            type: Boolean,
            default: false
          }
        },

        template: `
        <div v-bind:class="inline ? 'inline-field' : 'field'">
          <label v-bind:class="inline ? 'inline-input-label' : 'input-label'">
            {{ label }}
          </label>
          <select
            :value="modelValue"
            v-bind="$attrs"
            @change="$emit('update:data', $event.target.value)"
            v-bind:class="selectClass"
          >
            <option
              v-for="option in options"
              :value="option.value"
              :key="option"
              :selected="option.value === modelValue"
            >{{ option.label }}</option>
          </select>
        </div>
        `
      },
    }
  }).mount(ctx.root);

  ctx.handleEvent("update", ({ fields }) => {
    setValues(fields);
  });

  ctx.handleSync(() => {
    // Synchronously invokes change listeners
    document.activeElement &&
      document.activeElement.dispatchEvent(new Event("change", { bubbles: true }));
  });

  function setValues(fields) {
    for (const field in fields) {
      app.fields[field] = fields[field];
    }
  }
}

